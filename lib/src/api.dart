import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rdcli/src/endpoints.dart';
import 'package:rdcli/src/exceptions/add_magnet_exception.dart';
import 'package:rdcli/src/exceptions/select_files_exception.dart';
import 'package:rdcli/src/exceptions/torrent_info_exception.dart';
import 'package:rdcli/src/exceptions/unrestrict_link_exception.dart';

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

  /// Add the magnet to the download queue. This does not automatically start
  /// the download; see [startDownload].
  ///
  /// Returns the id of the torrent.
  Future<String> addMagnet(String link) async {
    final response = await http.post(
      Uri.parse(apiEndpointAddMagnet),
      headers: _authHeaders,
      body: {'magnet': link},
    );

    if (response.statusCode != 201) {
      throw AddMagnetException(
        'Status code: ${response.statusCode}\n${response.body}',
      );
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    return j['id'] as String;
  }

  /// Begin downloading the torrent for an uploaded magnet.
  Future<void> startDownload(String id) async {
    final response = await http.post(
      Uri.parse('$apiEndpointSelectFiles/$id'),
      headers: _authHeaders,
      body: {'files': 'all'},
    );

    if (response.statusCode != 204) {
      throw SelectFilesException(
        'Status code: ${response.statusCode}\n${response.body}',
      );
    }
  }

  /// Returns the private link to an uploaded torrent by [addMagnet].
  Future<String> getPrivateLink(String id) async {
    final response = await http.get(
      Uri.parse('$apiEndpointTorrentInfo/$id'),
      headers: _authHeaders,
    );

    if (response.statusCode != 200) {
      throw TorrentInfoException(
        'Status code: ${response.statusCode}\n${response.body}',
      );
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    final links = j['links'] as List<dynamic>;
    return links.first as String;
  }

  /// Find the torrent link from the torrent id.
  Future<bool> isDownloaded(String id) async {
    final response = await http.get(
      Uri.parse('$apiEndpointTorrentInfo/$id'),
      headers: _authHeaders,
    );

    if (response.statusCode != 200) {
      throw TorrentInfoException(
        'Status code: ${response.statusCode}\n${response.body}',
      );
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    final status = j['status'] as String;
    return status == 'downloaded';
  }

  /// Unrestricts a torrent's private link and returns the public link.
  Future<String> getPublicLink(String link) async {
    final response = await http.post(
      Uri.parse(apiEndpointUnrestrictLink),
      headers: _authHeaders,
      body: {'link': link},
    );

    if (response.statusCode != 200) {
      throw UnrestrictLinkException(
        'Status code: ${response.statusCode}\n${response.body}',
      );
    }

    final j = jsonDecode(response.body) as Map<String, dynamic>;
    return j['download'] as String;
  }
}
