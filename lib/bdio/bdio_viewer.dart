import 'package:flutter/material.dart';
import 'package:synopsys_detect_app/bdio/model/entry.dart';

class BdioViewer extends StatelessWidget {
  final List<Entry> bdioEntries;

  const BdioViewer({Key key, this.bdioEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            shrinkWrap: true,
            children: bdioEntries.map((entry) {
              return Text(entry.id + "\n    " + entry.dependencies.map((dependency) => dependency.id).join("\n    "));
            }).toList()));
  }
}
