
class HttpException implements Exception {
  final String message;
  const HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
