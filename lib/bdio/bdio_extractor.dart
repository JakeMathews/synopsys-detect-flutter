import 'dart:io';

import 'package:archive/archive.dart';

class BdioExtractor {
  void extractBdio(File bdio2File, Directory outputDirectory) {
    final bdioBytes = bdio2File.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bdioBytes);

    for (final ArchiveFile file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        var outputFile = File(outputDirectory.path + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        print("Wrote file to ${outputFile.absolute.path}");
      } else {
        var directory = Directory('out/' + filename)..create(recursive: true);
        print("Wrote directory to ${directory.absolute.path}");
      }
    }
  }
}
