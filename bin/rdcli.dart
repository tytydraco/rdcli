import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:rdcli/rdcli.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();
  parser
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Shows program usage.',
      callback: (value) {
        if (value) stdout.writeln(parser.usage);
      },
    )
    ..addOption(
      'api-key',
      abbr: 'k',
      help: 'Real-Debrid API key.',
      mandatory: true,
    )
    ..addOption(
      'output-directory',
      abbr: 'o',
      help: 'Output directory.',
      defaultsTo: '.',
    );

  final results = parser.parse(arguments);
  final magnetLinks = results.rest;

  if (magnetLinks.isEmpty) {
    stderr.writeln('No magnet URLs specified.');
    stdout
      ..writeln()
      ..writeln(parser.usage);
    exit(1);
  }

  final apiKey = results['api-key'] as String;
  final outputDirectoryStr = results['output-directory'] as String;

  final outputDirectory = Directory(outputDirectoryStr);
  if (!outputDirectory.existsSync()) {
    stderr.writeln('Output directory not found.');
    exit(1);
  }

  for (final magnetLink in magnetLinks) {
    final rdcli = Rdcli(apiKey: apiKey, magnet: magnetLink);

    final downloadLink = await rdcli.download();

    final response = await http.get(Uri.parse(downloadLink));
    final filename = basename(downloadLink);
    final file = File(join(outputDirectoryStr, filename));
    await file.writeAsBytes(response.bodyBytes);

    stdout.writeln('Done: $filename');
  }
}
