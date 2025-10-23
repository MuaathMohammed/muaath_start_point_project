extension ListExtensions<T> on List<T> {
  T? firstOrNull() {
    return isEmpty ? null : first;
  }

  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastOrNull() {
    return isEmpty ? null : last;
  }

  T? elementAtOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }
}
