import 'dart:async';
import 'dart:ui';

abstract class SearchBuilder<T> {
  bool isMatch(T item, String keyword);
}

abstract class SearchBuilderByInput<T, I> {
  bool isMatch(T item, I input);
}

abstract class ComplexSearchBuilder<T> {
  bool isMatch(T item, Map searchParams);
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel(); // Hủy nếu đang chạy
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
