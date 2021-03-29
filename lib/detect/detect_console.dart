import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detect.dart';

typedef NewDataCallback = void Function(OutputLine);

class DetectConsole extends StatefulWidget {
  final DetectConsoleState state;

  const DetectConsole(this.state, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class DetectConsoleState extends State<DetectConsole> {
  bool scrollToBottom = false;
  List<OutputLine> lines = [];

  DetectConsoleState({this.scrollToBottom});

  void shouldScrollToBottom(bool shouldScrollToBottom) {
    scrollToBottom = shouldScrollToBottom;
    if (scrollToBottom) _scrollToBottom();
  }

  void addLines(List<OutputLine> lines) {
    setState(() {
      this.lines.addAll(lines);
    });

    if (scrollToBottom) _scrollToBottom();
  }

  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    var textWidgets = lines.map((line) {
      var textStyle = TextStyle(color: line.isError ? Colors.red : Colors.black);
      return Text(line.data, style: textStyle);
    }).toList();

    return Expanded(
        child: ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: textWidgets,
    ));
  }
}
