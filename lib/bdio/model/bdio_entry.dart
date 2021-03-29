import 'package:json_annotation/json_annotation.dart';
import 'package:synopsys_detect_app/bdio/model/dependency.dart';

part 'bdio_entry.g.dart';

@JsonSerializable()
class Entry {
  @JsonKey(name: "@id")
  final String id;
  @JsonKey(name: "@graph")
  final List<Dependency> dependencies;

  Entry(this.id, this.dependencies);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);
}
