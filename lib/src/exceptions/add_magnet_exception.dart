/// Exception thrown when adding a magnet fails. This may
/// imply a bad magnet URL.
class AddMagnetException implements Exception {
  /// Creates a new [AddMagnetException] with a [message].
  AddMagnetException(this.message);

  /// The message.
  final String message;

  @override
  String toString() {
    return 'AddMagnetException: $message';
  }
}
