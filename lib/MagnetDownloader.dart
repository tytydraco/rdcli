import 'dart:io';

import 'package:rdcli/rdcli.dart';

/// Downloads a magnet using Real Debrid.
class MagnetDownloader {
  /// Creates a new [MagnetDownloader] given a [magnet] link.
  MagnetDownloader({
    required this.magnet,
    required this.rdcli,
  });

  /// The magnet link.
  final String magnet;

  /// The [Rdcli] instance.
  final Rdcli rdcli;

  /// Download the magnet.
  Future<String> download() async {
    // 1. Add magnet
    final id = await rdcli.addMagnet(magnet);

    // 2. Select files
    await rdcli.selectFilesToDownload(id);

    // 2.5. Wait for download to finish
    while (!(await rdcli.getIsDownloadedFromId(id))) {
      sleep(const Duration(seconds: 1));
    }

    // 3. Get info
    final link = await rdcli.getTorrentLinkFromId(id);

    // 4. Unrestrict link
    final downloadLink = await rdcli.unrestrictLink(link);

    return downloadLink;
  }
}
