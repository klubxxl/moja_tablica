class httpException implements Exception {
  String massage;
  httpException(this.massage);

  @override
  String toString() {
    return massage;
  }
}
