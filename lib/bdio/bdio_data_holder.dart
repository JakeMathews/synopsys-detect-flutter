import 'package:flutter/widgets.dart';
import 'package:synopsys_detect_app/bdio/model/bdio_entry.dart';

class BdioDataHolder extends InheritedWidget {
  final List<Entry> bdioEntries;

  BdioDataHolder(this.bdioEntries, {Widget child}) : super(child: child);

  static BdioDataHolder of(BuildContext context) => context.dependOnInheritedWidgetOfExactType(aspect: BdioDataHolder);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
