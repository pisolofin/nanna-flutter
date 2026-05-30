class NaException implements Exception {
  /// A message describing the format error.
  final String message;

  /// Parent exception.
  final Exception? innerException;

  /// Extra data.
  final dynamic data;

  NaException(this.message, { this.innerException, this.data });

  @override
  String toString() {
    if (this.innerException != null) {
      return '${this.message}\nInner exception: ${this.innerException.toString()}';
    }else {
      return this.message;
    }
  }
}
