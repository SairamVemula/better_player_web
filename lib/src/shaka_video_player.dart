import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:js_util';

import 'package:better_player/better_player.dart';
import 'shims/dart_ui.dart' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:better_player/src/video_player/video_player_platform_interface.dart';
import 'shaka/shaka.dart' as shaka;
import 'utils.dart';
import 'video_element_player.dart';

const String _kMuxScriptUrl =
    'https://cdnjs.cloudflare.com/ajax/libs/mux.js/5.10.0/mux.min.js';
const String _kShakaScriptUrl = kReleaseMode
    ? 'https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.3.6/shaka-player.compiled.js'
    : 'https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.3.6/shaka-player.compiled.debug.js';

class ShakaVideoPlayer extends VideoElementPlayer {
  ShakaVideoPlayer({
    required String key,
    bool withCredentials = false,
    @visibleForTesting StreamController<VideoEvent>? eventController,
  })  : _withCredentials = withCredentials,
        super(eventController: eventController, key: key);

  late shaka.Player _player;

  BetterPlayerDrmConfiguration? _drmConfiguration;
  final bool _withCredentials;

  @override
  String? src;

  bool get _hasDrm =>
      _drmConfiguration?.certificateUrl != null ||
      _drmConfiguration?.licenseUrl != null;

  String get _drmServer {
    switch (_drmConfiguration?.drmType) {
      case BetterPlayerDrmType.widevine:
        return 'com.widevine.alpha';
      case BetterPlayerDrmType.playready:
        return 'com.microsoft.playready';
      case BetterPlayerDrmType.clearKey:
        return 'org.w3.clearkey';
      default:
        return '';
    }
  }

  setDataSource(DataSource dataSource) async {
    switch (dataSource.sourceType) {
      case DataSourceType.network:
        // Do NOT modify the incoming uri, it can be a Blob, and Safari doesn't
        // like blobs that have changed.
        src = dataSource.uri ?? '';
        break;
      case DataSourceType.asset:
        String assetUrl = dataSource.asset!;
        if (dataSource.package != null && dataSource.package!.isNotEmpty) {
          assetUrl = 'packages/${dataSource.package}/$assetUrl';
        }
        assetUrl = ui.webOnlyAssetManager.getAssetUrl(assetUrl);
        src = assetUrl;
        break;
      case DataSourceType.file:
        throw UnimplementedError(
            'web implementation of video_player cannot play local files');
    }
    _drmConfiguration = BetterPlayerDrmConfiguration(
      certificateUrl: dataSource.certificateUrl,
      clearKey: dataSource.clearKey,
      drmType: dataSource.drmType,
      headers: dataSource.drmHeaders,
      licenseUrl: dataSource.licenseUrl,
    );
  }

  @override
  html.VideoElement createElement(int textureId) {
    return html.VideoElement()
      ..id = 'shakaVideoPlayer-$textureId'
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';
  }

  @override
  Future<void> initialize() async {
    try {
      await _loadScript();
      await _afterLoadScript();
    } on html.Event catch (ex) {
      eventController.addError(PlatformException(
        code: ex.type,
        message: 'Error loading Shaka Player: $_kShakaScriptUrl',
      ));
    } catch (e) {
      throw ErrorDescription(e.toString());
    }
  }

  Future<dynamic> _loadScript() async {
    if (shaka.isNotLoaded) {
      await loadScript('muxjs', _kMuxScriptUrl);
      await loadScript('shaka', _kShakaScriptUrl);
    }
  }

  Future<void> _afterLoadScript() async {
    videoElement
      // Set autoplay to false since most browsers won't autoplay a video unless it is muted
      ..autoplay = false
      ..controls = false;

    // Allows Safari iOS to play the video inline
    videoElement.setAttribute('playsinline', 'true');

    try {
      shaka.installPolyfills();
    } catch (e) {
      inspect(e);
    }

    if (shaka.Player.isBrowserSupported()) {
      _player = shaka.Player(videoElement);

      setupListeners();

      try {
        if (_hasDrm) {
          if (_drmConfiguration?.licenseUrl?.isNotEmpty ?? false) {
            _player.configure(
              jsify({
                "drm": {
                  "servers": {_drmServer: _drmConfiguration?.licenseUrl!}
                }
              }),
            );
          }
        }

        _player
            .getNetworkingEngine()
            .registerRequestFilter(allowInterop((type, request) {
          request.allowCrossSiteCredentials = _withCredentials;

          if (type == shaka.RequestType.license &&
              _hasDrm &&
              _drmConfiguration?.headers?.isNotEmpty == true) {
            request.headers = jsify(_drmConfiguration?.headers!);
          }
        }));

        await promiseToFuture(_player.load(src!));
      } on shaka.Error catch (ex) {
        _onShakaPlayerError(ex);
      }
    } else {
      throw UnsupportedError(
          'web implementation of video_player does not support your browser');
    }
  }

  void _onShakaPlayerError(shaka.Error error) {
    eventController.addError(PlatformException(
      code: shaka.errorCodeName(error.code),
      message: shaka.errorCategoryName(error.category),
      details: error,
    ));
  }

  @override
  @protected
  void setupListeners() {
    super.setupListeners();

    // Listen for error events.
    _player.addEventListener(
      'error',
      allowInterop((event) => _onShakaPlayerError(event.detail)),
    );
  }

  @override
  void dispose() {
    _player.destroy();
    super.dispose();
  }

  @override
  Future<void> setTrackParameters(int? width, int? height, int? bitrate) async {
    videoElement.width = width ?? 350;
    videoElement.height = height ?? 250;
  }

  @override
  Future<DateTime?> getAbsolutePosition() async {
    return DateTime.fromMillisecondsSinceEpoch(videoElement.duration.toInt());
  }
}
