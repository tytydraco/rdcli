import 'dart:io';

/// Test magnet of an Arch Linux ISO.
/// https://webtorrent.io/free-torrents
const testMagnet =
    'magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c&dn=Big+Buck+Bunny&tr=udp%3A%2F%2Fexplodie.org%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.empire-js.us%3A1337&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=wss%3A%2F%2Ftracker.btorrent.xyz&tr=wss%3A%2F%2Ftracker.fastcast.nz&tr=wss%3A%2F%2Ftracker.openwebtorrent.com&ws=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2F&xs=https%3A%2F%2Fwebtorrent.io%2Ftorrents%2Fbig-buck-bunny.torrent';

/// The SHA256 checksum for [testMagnet].
const testMagnetSha256 =
    '0fe0f7b56d87a97532e74a56d60315b3c27f02be29139f083fd6513d3cbf57fa';

final String apiKey = _getApiKey();

String _getApiKey() {
  final environment = Platform.environment;
  if (!environment.containsKey('RDCLI_API_KEY')) {
    stderr.writeln(
      'Environmental variable `RDCLI_API_KEY` must be set to run tests.',
    );
    exit(1);
  }

  return Platform.environment['RDCLI_API_KEY']!;
}
