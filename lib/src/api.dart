import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rdcli/src/endpoints.dart';

/// The API client.
class Api {
  /// Creates a new [Api].
  Api({
    required this.apiKey,
  });

  /// The API key.
  final String apiKey;

  /// HTTP headers with RealDebrid authentication.
  late final _authHeaders = {'Authorization': 'Bearer $apiKey'};

  /// Add the magnet to the download queue.
  Future<String> addMagnet(String link) async {
    final response = await http.post(
      Uri.parse(apiEndpointAddMagnet),
      headers: _authHeaders,
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
        '$apiEndpointSelectFiles/$id',
      ),
      headers: _authHeaders,
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
      Uri.parse('$apiEndpointTorrentInfo/$id'),
      headers: _authHeaders,
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
      Uri.parse('$apiEndpointTorrentInfo/$id'),
      headers: _authHeaders,
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
      Uri.parse(apiEndpointUnrestrictLink),
      headers: _authHeaders,
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
