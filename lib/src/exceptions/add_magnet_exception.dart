import 'package:rdcli/src/exceptions/rdcli_exception.dart';

/// Exception thrown when adding a magnet fails. This may
/// imply a bad magnet URL.
class AddMagnetException extends RdcliException {
  /// Creates a new [AddMagnetException] with a [message].
  const AddMagnetException(super.message);
}
