import 'package:better_player/better_player.dart';
import 'package:better_player_web_example/constants.dart';
import 'package:flutter/material.dart';

class DrmPage extends StatefulWidget {
  @override
  _DrmPageState createState() => _DrmPageState();
}

class _DrmPageState extends State<DrmPage> {
  late BetterPlayerController _tokenController;
  late BetterPlayerController _widevineController;
  late BetterPlayerController _fairplayController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    // BetterPlayerDataSource _tokenDataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.network,
    //   Constants.tokenEncodedHlsUrl,
    //   videoFormat: BetterPlayerVideoFormat.hls,
    //   drmConfiguration: BetterPlayerDrmConfiguration(
    //       drmType: BetterPlayerDrmType.token,
    //       token: Constants.tokenEncodedHlsToken),
    // );
    // _tokenController = BetterPlayerController(betterPlayerConfiguration);
    // _tokenController.setupDataSource(_tokenDataSource);

    // _widevineController = BetterPlayerController(betterPlayerConfiguration);
    // BetterPlayerDataSource _widevineDataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.network,
    //   Constants.widevineVideoUrl,
    //   drmConfiguration: BetterPlayerDrmConfiguration(
    //       drmType: BetterPlayerDrmType.widevine,
    //       licenseUrl: Constants.widevineLicenseUrl,
    //       headers: {"Test": "Test2"}),
    // );
    // _widevineController.setupDataSource(_widevineDataSource);

    _fairplayController = BetterPlayerController(betterPlayerConfiguration);
    BetterPlayerDataSource _fairplayDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://itap-uploads.s3.ap-south-1.amazonaws.com/2023/09/Shameless/fps_hls/master.m3u8',
      drmConfiguration: BetterPlayerDrmConfiguration(
        drmType: BetterPlayerDrmType.fairplay,
        certificateUrl:
            'https://itap-uploads.s3.ap-south-1.amazonaws.com/fairplay.cer',
        licenseUrl:
            'https://license.vdocipher.com/auth/fps/eyJjb250ZW50QXV0aCI6ImV5SmpiMjUwWlc1MFNXUWlPaUkwTWpZMU1HWmxOVEEyTkdOak5qZzJNelkxTkRFMk5tVm1ObVUzT0RWa015SXNJbVY0Y0dseVpYTWlPakUyT1RZMU1ERXdNekI5Iiwic2lnbmF0dXJlIjoid0d3NUtYaHVScFBkNVVHTDoyMDIzMTAwNFQwOTE3MTAzOTJaOk1lTDlkeFN2aUp1SS1jZVI0ZHJxb004djgzU1dNWEJWTlFMQjAxSG1hN289In0=',
      ),
    );
    _fairplayController.setupDataSource(_fairplayDataSource);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DRM player"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     "Auth token based DRM.",
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            // AspectRatio(
            //   aspectRatio: 16 / 9,
            //   child: BetterPlayer(controller: _tokenController),
            // ),
            // const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     "Widevine - license url based DRM. Works only for Android.",
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            // AspectRatio(
            //   aspectRatio: 16 / 9,
            //   child: BetterPlayer(controller: _widevineController),
            // ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Fairplay - certificate url based EZDRM. Works only for iOS.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _fairplayController),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
