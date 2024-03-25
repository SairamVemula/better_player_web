# better_player_web

A new Flutter plugin project.

## Getting Started

Add in better_player's `pubspec.yaml` under `plugins > web > default_package: better_player_web`

TODO to for it to work on web need to add

In your flutter project add this in `index.html`.

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.4.2/shaka-player.compiled.debug.min.js"
crossorigin="anonymous" referrerpolicy="no-referrer"></script>
```

If you want HLS to working in web then add this

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/mux.js/6.1.0/mux.min.js" crossorigin="anonymous"referrerpolicy="no-referrer"></script>
```

This function is added in `index.html` used in for fps reqeust transformation

```js
    function requestFilter(type, request) {
      console.log('request filter before license check', type, request);
      console.log(shaka.net.NetworkingEngine.RequestType);
      if (type !== shaka.net.NetworkingEngine.RequestType.LICENSE) {
        return;
      }

      const originalPayload = new Uint8Array(request.body);
      const base64Payload = shaka.util.Uint8ArrayUtils.toBase64(originalPayload);
      request.headers['Content-Type'] = 'application/json';
      request.body = '{"spc": "' + base64Payload + '"}';
      console.log('request filter after license check');
    }
```

Import into dart here [filters.dart](lib/src/filters.dart)

```dart
@JS('requestFilter')
external Function requestFilter;
```

TODO : Need to figure out how to do it in dart.

## Documentation

- [better_player_web.dart](lib/better_player_web.dart) in this file `BetterPlayerPlugin` class is overriding all methods and properties of [video_player_platform_interface.dart](https://github.com/jhomlala/betterplayer/blob/master/lib/src/video_player/video_player_platform_interface.dart)
- better_player_web has implemented [video_player.dart](lib/src/video_player.dart) out of [video_player_platform_interface.dart](https://github.com/jhomlala/betterplayer/blob/master/lib/src/video_player/video_player_platform_interface.dart)
- `HtmlElementView` flutter component is used to inject a html element into flutter.
- [shaka_video_player.dart](lib/src/shaka_video_player.dart) This is main dart class which has all the code implemented.
- `better_player_web` is internally using [flutter_shaka](https://pub.dev/packages/flutter_shaka) for its core implementation.
