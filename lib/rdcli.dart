import 'dart:io';

import 'package:rdcli/src/api.dart';

/// Downloads a magnet using Real Debrid.
class Rdcli {
  /// Creates a new [Rdcli] given a [magnet] link and [apiKey].
  Rdcli({
    required this.apiKey,
    required this.magnet,
  });

  /// The API key.
  final String apiKey;

  /// The magnet link.
  final String magnet;

  /// The [Api] instance.
  late final api = Api(apiKey: apiKey);

  /// Download the magnet.
  Future<String> download() async {
    // 1. Add magnet
    final id = await api.addMagnet(magnet);

    // 2. Select files
    await api.selectFilesToDownload(id);

    // 2.5. Wait for download to finish
    while (!(await api.getIsDownloadedFromId(id))) {
      sleep(const Duration(seconds: 1));
    }

    // 3. Get info
    final link = await api.getTorrentLinkFromId(id);

    // 4. Unrestrict link
    final downloadLink = await api.unrestrictLink(link);

    return downloadLink;
  }
}
