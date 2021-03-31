import 'dart:io';

import 'package:glob/glob.dart';

class BdioFinder {
  final bdioFileGlob = Glob("/**/*.bdio");
  final bdioEntryFileGlob = Glob("/**/bdio-entry-*.jsonld");

  List<File> findEntryFiles(Directory directory) {
    return _searchForFiles(directory, bdioEntryFileGlob);
  }

  List<File> findBdioFiles(Directory directory) {
    return _searchForFiles(directory, bdioFileGlob);
  }

  List<File> findMostRecentBdio(Directory runsDirectory) {
    var runDirectories = runsDirectory.listSync();

    Directory mostRecentDirectory;
    for (var directoryEntity in runDirectories) {
      if (directoryEntity.statSync().type != FileSystemEntityType.directory) {
        continue;
      }

      var directory = Directory(directoryEntity.path);
      if (mostRecentDirectory == null) {
        mostRecentDirectory = directory;
      }

      var mostRecentlyModified = mostRecentDirectory.statSync().modified;
      if (directory.statSync().modified.isAfter(mostRecentlyModified)) {
        mostRecentDirectory = directory;
      }
    }

    return _searchForFiles(mostRecentDirectory, bdioFileGlob);
  }

  List<File> _searchForFiles(Directory directory, Glob fileGlob) {
    List<File> files = [];
    List<FileSystemEntity> fileSystemEntities = directory.listSync(recursive: true);

    for (var entity in fileSystemEntities) {
      var file = File(entity.uri.path);
      if (fileGlob.matches(file.absolute.path)) {
        files.add(file);
      }
    }

    return files;
  }
}
