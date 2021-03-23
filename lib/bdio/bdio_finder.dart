import 'dart:io';

class BdioFinder {
  List<File> findEntryFiles(Directory directory) {
    return _searchForFiles(directory, ".jsonld");
  }

  List<File> findBdioFiles(Directory directory) {
    return _searchForFiles(directory, ".bdio");
  }

  List<File> findMostRecentBdio(Directory runsDirectory) {
    var runDirectories = runsDirectory.listSync();

    Directory mostRecentDirectory = null;
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

    return _searchForFiles(mostRecentDirectory, ".bdio");
  }

  List<File> _searchForFiles(Directory directory, String fileExtension) {
    List<File> files = [];
    List<FileSystemEntity> fileSystemEntities = directory.listSync(recursive: true);

    for (var entity in fileSystemEntities) {
      var file = File(entity.uri.path);
      if (file.path.endsWith(fileExtension)) {
        files.add(file);
      }
    }

    return files;
  }
}
