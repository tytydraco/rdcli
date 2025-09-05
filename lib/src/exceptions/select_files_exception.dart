/// Exception thrown when files are unable to be selected for download.
class SelectFilesException implements Exception {
  /// Creates a new [SelectFilesException] with a [message].
  SelectFilesException(this.message);

  /// The message.
  final String message;

  @override
  String toString() {
    return 'SelectFilesException: $message';
  }
}
