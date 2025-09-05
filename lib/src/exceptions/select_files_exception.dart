import 'package:rdcli/src/exceptions/rdcli_exception.dart';

/// Exception thrown when files are unable to be selected for download.
class SelectFilesException extends RdcliException {
  /// Creates a new [SelectFilesException] with a [message].
  const SelectFilesException(super.message);
}
