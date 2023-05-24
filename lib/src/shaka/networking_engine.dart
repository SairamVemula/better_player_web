@JS('shaka')
library shaka;

// ignore: depend_on_referenced_packages
import 'package:js/js.dart';

@JS('net.NetworkingEngine')
class NetworkingEngine {
  external void registerRequestFilter(filter);
}

/*
extension NetworkingEngineExt on NetworkingEngine {
  void registerRequestFilter(RequestFilter filter) {
    privateRegisterRequestFilter(allowInterop(filter));
  }
}
*/
