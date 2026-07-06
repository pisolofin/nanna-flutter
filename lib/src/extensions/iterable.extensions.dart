extension NaIterableExtensions on Iterable {
  /// Finds the index of item into list.
  /// Returns -1 if not element found.
  int indexWhere<T>(bool Function(T item) checkFn) {
    int currentIndex = 0;

    for (var item in this) {
      if (checkFn(item)) {
        return currentIndex;
      }
      currentIndex++;
    }

    return -1;
  }
}
