import 'package:flutter/material.dart';
import 'package:synopsys_detect_app/bdio/bdio_service.dart';
import 'package:synopsys_detect_app/bdio/bdio_viewer.dart';

import 'bdio/model/bdio_entry.dart';
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
    var detectRunner = DetectRunner();
    await detectRunner.runScan((OutputLine newData) {
      setState(() {
        lines.add(newData);
        _scrollToBottom();
      });
    });

    var bdioService = BdioService();
    setState(() {
      bdioEntries = bdioService.findMostRecentBdio();
    });
  }

  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
