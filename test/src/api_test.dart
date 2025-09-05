import 'dart:io';

import 'package:rdcli/src/api.dart';
import 'package:rdcli/src/exceptions/add_magnet_exception.dart';
import 'package:rdcli/src/exceptions/select_files_exception.dart';
import 'package:rdcli/src/exceptions/torrent_info_exception.dart';
import 'package:rdcli/src/exceptions/unrestrict_link_exception.dart';
import 'package:test/test.dart';

import '../config.dart';

void main() {
  Directory? testDir;
  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp('RDCLI_TEST_');
  });
  tearDownAll(() async {
    await testDir?.delete(recursive: true);
  });

  final api = Api(apiKey: apiKey);
  String? workingId;
  String? workingLink;

  group(
    'Add magnet',
    () {
      test('Valid link', () async {
        workingId = await api.addMagnet(testMagnet);
        expect(workingId!.isNotEmpty, true);
      });
      test('Invalid link', () async {
        expect(
          () => api.addMagnet('12345'),
          throwsA(isA<AddMagnetException>()),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  group(
    'Select files for download',
    () {
      test('Valid id', () async {
        expect(
          () => api.startDownload(workingId!),
          returnsNormally,
        );
      });
      test('Invalid id', () async {
        expect(
          () => api.startDownload('12345'),
          throwsA(isA<SelectFilesException>()),
        );
      });
    },
  );

  group(
    'Get torrent link from id',
    () {
      test('Valid id', () async {
        workingLink = await api.getPrivateLink(workingId!);
        expect(workingLink!.isNotEmpty, true);
      });
      test('Invalid id', () async {
        expect(
          () => api.getPrivateLink('12345'),
          throwsA(isA<TorrentInfoException>()),
        );
      });
    },
  );

  group(
    'Get is downloaded from id',
    () {
      test('Valid id', () async {
        expect(
          () => api.isDownloaded(workingId!),
          returnsNormally,
        );
      });
      test('Invalid id', () async {
        expect(
          () => api.isDownloaded('12345'),
          throwsA(isA<TorrentInfoException>()),
        );
      });
    },
  );

  group(
    'Unrestrict link',
    () {
      test('Valid link', () async {
        final publicLink = await api.getPublicLink(workingLink!);
        expect(publicLink.isNotEmpty, true);
      });
      test('Invalid link', () async {
        expect(
          () => api.getPublicLink('12345'),
          throwsA(isA<UnrestrictLinkException>()),
        );
      });
    },
  );
}
