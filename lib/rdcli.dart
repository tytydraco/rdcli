import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:rdcli/src/api.dart';

export 'src/api.dart';
export 'src/endpoints.dart';
export 'src/exceptions/add_magnet_exception.dart';
export 'src/exceptions/rdcli_exception.dart';
export 'src/exceptions/select_files_exception.dart';
export 'src/exceptions/torrent_info_exception.dart';
export 'src/exceptions/unrestrict_link_exception.dart';

/// Downloads a magnet using Real Debrid.
class Rdcli {
  /// Creates a new [Rdcli] given a [magnet] link and [apiKey].
  Rdcli({
    required this.apiKey,
    required this.magnet,
    this.quiet = false,
  });

  /// The API key.
  final String apiKey;

  /// The magnet link.
  final String magnet;

  /// Whether to silence logging output.
  final bool quiet;

  /// The [Api] instance.
  late final api = Api(apiKey: apiKey);

  Future<File> _saveToDisk(String url, Directory out) async {
    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();

    final filename = basename(url);
    final file = File(join(out.path, filename));
    final sink = file.openWrite();

    final total = response.contentLength ?? 0;
    var received = 0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;

        // Print progress if verbose.
        if (!quiet) {
          final progress = (received / total * 100).toStringAsFixed(2);
          stdout.write(
            '\x1B[2K\rProgress: $progress% ($received/$total)',
          );
        }
      }
    } finally {
      await sink.close();

      // Print newline if verbose to clear progress line.
      if (!quiet) stdout.writeln();
    }

    return file;
  }

  /// Download the magnet and return the public link.
  Future<String> downloadLink() async {
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
    return api.getPublicLink(link);
  }

  /// Download the magnet.
  Future<File> download(Directory out) async {
    final link = await downloadLink();
    final file = await _saveToDisk(link, out);

    return file;
  }
}
