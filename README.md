# better_player_web

A new Flutter plugin project.

## Getting Started

Add in better_player's `pubspec.yaml` under `plugins > web > default_package: better_player_web`

## Documentation

- [better_player_web.dart](lib/better_player_web.dart) in this file `BetterPlayerPlugin` class is overriding all methods and properties of [video_player_platform_interface.dart](https://github.com/jhomlala/betterplayer/blob/master/lib/src/video_player/video_player_platform_interface.dart)
- better_player_web has implemented [video_player.dart](lib/src/video_player.dart) out of [video_player_platform_interface.dart](https://github.com/jhomlala/betterplayer/blob/master/lib/src/video_player/video_player_platform_interface.dart)
- `HtmlElementView` flutter component is used to inject a html element into flutter.
- [shaka_video_player.dart](lib/src/shaka_video_player.dart) This is main dart class which has all the code implemented.
- `better_player` is internally using [flutter_shaka](https://pub.dev/packages/flutter_shaka) for its core implementation.
