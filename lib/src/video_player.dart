import 'dart:async';

// ignore: implementation_imports, depend_on_referenced_packages
import 'package:better_player/src/video_player/video_player_platform_interface.dart';

abstract class VideoPlayer {
  const VideoPlayer();

  String? get src;
  Stream<VideoEvent> get events;

  void registerElement(int textureId);

  Future<void> initialize();

  Future<void> play();

  Future<void> setDataSource(DataSource dataSource);

  Future<void> setTrackParameters(int? width, int? height, int? bitrate);

  Future<DateTime?> getAbsolutePosition();

  void pause();

  void setLooping(bool value);

  void setVolume(double volume);

  void setPlaybackSpeed(double speed);

  void seekTo(Duration position);

  Duration getPosition();

  void dispose();
}
