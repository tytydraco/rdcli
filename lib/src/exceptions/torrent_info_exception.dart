import 'package:rdcli/src/exceptions/rdcli_exception.dart';

/// Exception thrown when unable to fetch torrent info.
class TorrentInfoException extends RdcliException {
  /// Creates a new [TorrentInfoException] with a [message].
  const TorrentInfoException(super.message);
}
