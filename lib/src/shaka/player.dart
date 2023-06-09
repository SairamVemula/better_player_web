@JS('shaka')
library shaka;

import 'dart:html' as html;

// ignore: depend_on_referenced_packages
import 'package:js/js.dart';
import 'networking_engine.dart';

@JS()
class Player {
  external Player(html.VideoElement element);

  external static bool isBrowserSupported();

  external bool configure(Object config);
  external Future<void> load(String src);
  external Future<void> destroy();

  external NetworkingEngine getNetworkingEngine();

  external void addEventListener(String event, Function callback);
}
