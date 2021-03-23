import 'dart:convert';
import 'dart:io';

import 'package:synopsys_detect_app/bdio/model/entry.dart';

class BdioParser {
  List<Entry> parseEntryFiles(List<File> entryFiles) {
    return entryFiles.map((file) {
      var jsonMap = jsonDecode(file.readAsStringSync());
      return Entry.fromJson(jsonMap);
    }).toList();
  }
}
