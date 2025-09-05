/// Base class [Exception] for Rdcli exceptions to implement.
abstract class RdcliException implements Exception {
  /// Creates a new [RdcliException] with a [message].
  const RdcliException(this.message);

  /// The exception message.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}
