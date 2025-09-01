import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// The API client.
class Rdcli {
  /// Creates a new [Rdcli].
  Rdcli({
    required this.apiKey,
  });

  /// The API key.
  final String apiKey;

  /// Add the magnet to the download queue.
  Future<String> addMagnet(String link) async {
    final response = await http.post(
      Uri.parse('https://api.real-debrid.com/rest/1.0/torrents/addMagnet'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
      body: {
        'magnet': link,
      },
    );

    if (response.statusCode != 201) {
      stderr
        ..writeln('Failed to add magnet:')
        ..writeln(response.body);
      exit(1);
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    return j['id'] as String;
  }

  /// Select which torrent to download files from.
  Future<void> selectFilesToDownload(String id) async {
    final response = await http.post(
      Uri.parse(
        'https://api.real-debrid.com/rest/1.0/torrents/selectFiles/$id',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
      body: {
        'files': 'all',
      },
    );

    if (response.statusCode != 204) {
      stderr
        ..writeln('Failed to select files:')
        ..writeln(response.body);
      exit(1);
    }
  }

  /// Find the torrent link from the torrent id.
  Future<String> getTorrentLinkFromId(String id) async {
    final response = await http.get(
      Uri.parse(
        'https://api.real-debrid.com/rest/1.0/torrents/info/$id',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode != 200) {
      stderr
        ..writeln('Failed to get torrent info:')
        ..writeln(response.body);
      exit(1);
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    final links = j['links'] as List<dynamic>;
    return links.first as String;
  }

  /// Find the torrent link from the torrent id.
  Future<bool> getIsDownloadedFromId(String id) async {
    final response = await http.get(
      Uri.parse(
        'https://api.real-debrid.com/rest/1.0/torrents/info/$id',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode != 200) {
      stderr
        ..writeln('Failed to check torrent download status:')
        ..writeln(response.body);
      exit(1);
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    final status = j['status'] as String;
    return status == 'downloaded';
  }

  /// Unrestricts a link to a torrent.
  Future<String> unrestrictLink(String link) async {
    final response = await http.post(
      Uri.parse(
        'https://api.real-debrid.com/rest/1.0/unrestrict/link',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
      body: {
        'link': link,
      },
    );

    if (response.statusCode != 200) {
      stderr
        ..writeln('Failed to unrestrict access link:')
        ..writeln(response.body);
      exit(1);
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    return j['download'] as String;
  }
}
