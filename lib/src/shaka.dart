@JS('shaka')
library shaka;

export 'shaka/player.dart';
export 'shaka/request.dart';
import 'dart:js';

// ignore: depend_on_referenced_packages
import 'package:js/js.dart';

bool get isLoaded => context.hasProperty('shaka');
bool get isNotLoaded => !isLoaded;

@JS('polyfill.installAll')
external void installPolyfills();

/// https://shaka-player-demo.appspot.com/docs/api/shaka.util.Error.html
@JS('util.Error')
class Error {
  @JS('Code')
  external static dynamic get codes;

  @JS('Category')
  external static dynamic get categories;

  @JS('Severity')
  external static dynamic get severities;

  external int get code;
  external int get category;
  external int get severity;
}

String errorCodeName(int code) {
  return _findName(context['shaka']['util']['Error']['Code'], code);
}

String errorCategoryName(int category) {
  return _findName(context['shaka']['util']['Error']['Category'], category);
}

String _findName(JsObject object, int value) {
  final List keys = context['Object'].callMethod('keys', [object]);

  try {
    return keys.firstWhere((k) => object[k] == value);
  } catch (_) {
    return '';
  }
}
