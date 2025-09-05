/// Exception thrown when unable to fetch torrent info.
class TorrentInfoException implements Exception {
  /// Creates a new [TorrentInfoException] with a [message].
  TorrentInfoException(this.message);

  /// The message.
  final String message;

  @override
  String toString() {
    return 'TorrentInfoException: $message';
  }
}
