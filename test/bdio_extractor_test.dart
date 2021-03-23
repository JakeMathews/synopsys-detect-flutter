import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synopsys_detect_app/bdio/bdio_extractor.dart';

void main() {
  test("bdio2 extraction test", () {
    var outputDirectory = Directory("out/");
    var bdio2File = File(
        "/Users/jakem/blackduck/runs/2021-03-23-16-35-40-469/bdio/blackducksoftware_blackduck_artifactory_master_blackduck_artifactory_automation_com_synopsys_integration_blackduck_artifactory_automation_7_3_1_SNAPSHOT_gradle_bom.bdio");

    var bdioExtractor = BdioExtractor();
    bdioExtractor.extractBdio(bdio2File, outputDirectory);
  });
}
