import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synopsys_detect_app/bdio/bdio_finder.dart';

void main() {
  test("bdio2 entry test", () {
    var outputDirectory = Directory("out/");

    var bdioFinder = BdioFinder();
    var findEntryFiles = bdioFinder.findEntryFiles(outputDirectory);

    print(findEntryFiles);
  });

  test("bdio2 file test", () {
    var runsDirectory = Directory("/Users/jakem/blackduck/runs");

    var bdioFinder = BdioFinder();
    var findEntryFiles = bdioFinder.findMostRecentBdio(runsDirectory);

    print(findEntryFiles);
  });
}
