import 'dart:async';

extension StreamUtils<T> on Stream<T> {
  Future<T> toFuture() {
    Completer<T> completer = Completer();
    T? value;
    listen(
      (event) => value = event,
      onDone: () {
        if (value != null) {
          completer.complete(value);
        } else {
          completer.completeError("noData");
        }
      },
    );
    return completer.future;
  }
}
