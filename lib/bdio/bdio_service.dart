import 'dart:io';

import 'package:synopsys_detect_app/bdio/model/bdio_entry.dart';

import 'bdio_extractor.dart';
import 'bdio_finder.dart';
import 'bdio_parser.dart';

class BdioService {
  List<Entry> findMostRecentBdio() {
    List<Entry> bdioEntries = [];

    BdioFinder bdioFinder = BdioFinder();
    BdioExtractor bdioExtractor = BdioExtractor();
    BdioParser bdioParser = BdioParser();

    var bdioFiles = bdioFinder.findMostRecentBdio(Directory("/Users/jakem/blackduck/runs"));
    var outputDirectory = Directory("out/");
    outputDirectory.delete(recursive: true);
    outputDirectory.create(recursive: true);

    for (var bdio2File in bdioFiles) {
      bdioExtractor.extractBdio(bdio2File, outputDirectory);
      var entryFiles = bdioFinder.findEntryFiles(outputDirectory);
      bdioEntries.addAll(bdioParser.parseEntryFiles(entryFiles));
    }

    return bdioEntries;
  }
}
