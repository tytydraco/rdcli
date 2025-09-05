import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:rdcli/rdcli.dart';
import 'package:rdcli/src/exceptions/add_magnet_exception.dart';
import 'package:test/test.dart';

import 'config.dart';

void main() {
  Directory? testDir;
  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp('RDCLI_TEST_');
  });
  tearDownAll(() async {
    await testDir?.delete(recursive: true);
  });

  group(
    'Rdcli intended behavior',
    () {
      final rdcli = Rdcli(magnet: testMagnet, apiKey: apiKey);
      File? file;

      test('Verify test torrent downloads', () async {
        file = await rdcli.download(testDir!);

        expect(file!.existsSync(), true);
      });

      test('Verify SHA256 checksum', () async {
        final inputStream = file!.openRead();
        final digest = await sha256.bind(inputStream).first;

        expect(digest.toString(), testMagnetSha256);
      });
    },
    timeout: const Timeout(Duration(minutes: 5)),
    skip: true,
  );

  group(
    'Rdcli error behavior',
    () {
      test('Bad magnet link', () async {
        final rdcli = Rdcli(magnet: '12345', apiKey: apiKey);
        expect(
          () => rdcli.download(testDir!),
          throwsA(isA<AddMagnetException>()),
        );
      });

      test('Bad API key', () async {
        final rdcli = Rdcli(magnet: testMagnet, apiKey: '12345');
        expect(
          () => rdcli.download(testDir!),
          throwsA(isA<AddMagnetException>()),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
