import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:synopsys_detect_app/bdio/bdio_data_holder.dart';

class BdioViewer extends StatefulWidget {
  const BdioViewer({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BdioViewerState();
  }
}

class BdioViewerState extends State<BdioViewer> {
  Map<String, bool> expandedMap = HashMap();

  @override
  Widget build(BuildContext context) {
    BdioDataHolder dataHolder = BdioDataHolder.of(context);

    List<Node> nodes = dataHolder.bdioEntries.map((entry) {
      return Node(
        label: "Entry ID: ${entry.id}",
        key: entry.id,
        data: entry.id,
        expanded: _isNodeExpanded(entry.id),
        children: entry.dependencies.map((dependency) {
          return Node(
            label: "Dependency ID: ${dependency.id}",
            key: dependency.id,
            data: dependency.id,
            expanded: _isNodeExpanded(dependency.id),
          );
        }).toList(),
      );
    }).toList(growable: true);

    TreeViewController _treeViewController = TreeViewController(children: nodes);

    return Expanded(
      child: TreeView(
        controller: _treeViewController,
        allowParentSelect: false,
        supportParentDoubleTap: false,
        onExpansionChanged: _expandNodeHandler,
        onNodeTap: (key) {
          setState(() {
            _treeViewController = _treeViewController.copyWith(selectedKey: key);
          });
        },
      ),
    );
  }

  void _expandNodeHandler(String nodeId, bool isExpanded) {
    expandedMap[nodeId] = isExpanded;
  }

  bool _isNodeExpanded(String nodeId) {
    bool nodeState = expandedMap[nodeId];
    return nodeState != null ? nodeState : false;
  }
}
