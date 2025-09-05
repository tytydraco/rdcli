import 'package:rdcli/src/exceptions/rdcli_exception.dart';

/// Exception thrown when unable to unrestrict download link.
class UnrestrictLinkException extends RdcliException {
  /// Creates a new [UnrestrictLinkException] with a [message].
  const UnrestrictLinkException(super.message);
}
