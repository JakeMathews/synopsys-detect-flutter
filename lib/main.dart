import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:synopsys_detect_app/bdio/bdio_extractor.dart';
import 'package:synopsys_detect_app/bdio/bdio_finder.dart';
import 'package:synopsys_detect_app/bdio/bdio_parser.dart';
import 'package:synopsys_detect_app/bdio/bdio_viewer.dart';

import 'bdio/model/entry.dart';
import 'detect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synopsys Detect',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MyHomePage(title: 'Synopsys Detect Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<OutputLine> lines = [];
  List<Entry> bdioEntries = [];

  void _runScan() async {
    print("Asking for source");
    var filePickerCross = await FilePickerCross.importFromStorage(type: FileTypeCross.any);

    var directory = filePickerCross.directory;
    if (directory.startsWith("//")) {
      directory = directory.substring(1);
    }
    print("Source directory: $directory");

    var detectArgs = ['--detect.source.path=$directory'];
    var properties = File(filePickerCross.path).readAsLinesSync().map((property) => '--$property');
    detectArgs.addAll(properties);

    var detectRunner = DetectRunner();

    print("Downloading Detect");
    var detectShFile = await detectRunner.downloadDetect();

    print("Starting Detect");
    var process = await detectRunner.runDetect(detectShFile, detectArgs, (newData) {
      setState(() {
        lines.add(newData);
        _scrollToBottom();
      });
    });

    print("Exit Code: ${await process.exitCode}");

    // BDIO 2 parsing

    BdioFinder bdioFinder = BdioFinder();
    BdioExtractor bdioExtractor = BdioExtractor();
    BdioParser bdioParser = BdioParser();

    var bdioFiles = bdioFinder.findMostRecentBdio(Directory("/Users/jakem/blackduck/runs"));
    var outputDirectory = Directory("out/");

    setState(() {
      bdioEntries = [];
      for (var bdio2File in bdioFiles) {
        bdioExtractor.extractBdio(bdio2File, outputDirectory);
        var entryFiles = bdioFinder.findEntryFiles(outputDirectory);
        bdioEntries.addAll(bdioParser.parseEntryFiles(entryFiles));
      }
    });
  }

  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    var bdioWidget = BdioViewer(bdioEntries: bdioEntries);

    var textWidgets = lines.map((line) {
      var textStyle = TextStyle(color: line.isError ? Colors.red : Colors.black);
      return Text(line.data, style: textStyle);
    }).toList();

    List<Widget> widgets = [];

    var detectOutput = Expanded(
        child: ListView(
      shrinkWrap: true,
      children: textWidgets,
      controller: _scrollController,
    ));

    widgets.add(detectOutput);
    widgets.add(bdioWidget);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: widgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runScan,
        tooltip: 'Run Scan',
        child: Icon(Icons.directions_run),
      ),
    );
  }
}
