import 'dart:async';

import 'package:injectable/injectable.dart';

@singleton
class SimpleNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  void notify() {
    _controller.add(null);
  }

  void addListener(Function(void value) callback) {
    _controller.stream.listen(callback);
  }
}
