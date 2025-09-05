/// Exception thrown when unable to unrestrict download link.
class UnrestrictLinkException implements Exception {
  /// Creates a new [UnrestrictLinkException] with a [message].
  UnrestrictLinkException(this.message);

  /// The message.
  final String message;

  @override
  String toString() {
    return 'UnrestrictLinkException: $message';
  }
}
