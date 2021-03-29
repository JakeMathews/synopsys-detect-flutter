import 'package:flutter/material.dart';
import 'package:synopsys_detect_app/bdio/bdio_service.dart';
import 'package:synopsys_detect_app/bdio/bdio_viewer.dart';
import 'package:synopsys_detect_app/detect/detect_console.dart';

import 'bdio/model/bdio_entry.dart';
import 'detect/detect.dart';

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
  bool scrollToBottom = true;

  List<Entry> bdioEntries = [];
  DetectConsoleState detectConsoleState = new DetectConsoleState(scrollToBottom: true);

  void _runScan() async {
    var detectRunner = DetectRunner();
    await detectRunner.runScan(_newDataCallback);

    var bdioService = BdioService();
    setState(() {
      bdioEntries = bdioService.findMostRecentBdio();
    });
  }

  void _newDataCallback(OutputLine outputLine) {
    setState(() {
      detectConsoleState.addLines([outputLine]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var detectConsole = DetectConsole(detectConsoleState);
    var bdioWidget = BdioViewer(bdioEntries: bdioEntries);

    List<Widget> widgets = [];
    widgets.add(detectConsole);
    widgets.add(bdioWidget);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(
            children: [
              Text("Scroll to bottom"),
              Checkbox(
                value: scrollToBottom,
                onChanged: (value) {
                  setState(() {
                    scrollToBottom = value;
                    detectConsoleState.shouldScrollToBottom(value);
                  });
                },
              ),
              Padding(padding: const EdgeInsets.all(20.0))
            ],
          )
        ],
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
