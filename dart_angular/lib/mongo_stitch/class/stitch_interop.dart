import 'package:js/js.dart';

typedef R Func1<A, R>(A a);

@JS('Promise')
class PromiseJsImpl<T> extends ThenableJsImpl<T> {
  external PromiseJsImpl(Function resolver);
  external static PromiseJsImpl<List> all(List<PromiseJsImpl> values);
  external static PromiseJsImpl reject(error);
  external static PromiseJsImpl resolve(value);
}

@anonymous
@JS()
abstract class ThenableJsImpl<T> {
  @anonymous
  external ThenableJsImpl JS$catch([Func1 onReject]);
  external ThenableJsImpl then([Func1 nResolve, Func1 onReject]);
}