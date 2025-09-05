import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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

  Future<File> _saveToDisk(String url, Directory out) async {
    final response = await http.get(Uri.parse(url));
    final filename = basename(url);
    final file = File(join(out.path, filename));
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  /// Download the magnet.
  Future<File> download(Directory out) async {
    // 1. Add magnet.
    final id = await api.addMagnet(magnet);

    // 2. Select files.
    await api.startDownload(id);

    // 2.5. Wait for download to finish.
    while (!(await api.isDownloaded(id))) {
      sleep(const Duration(seconds: 1));
    }

    // 3. Get info.
    final link = await api.getPrivateLink(id);

    // 4. Unrestrict link.
    final downloadLink = await api.getPublicLink(link);

    // 5. Save tp disk.
    final file = await _saveToDisk(downloadLink, out);

    return file;
  }
}
