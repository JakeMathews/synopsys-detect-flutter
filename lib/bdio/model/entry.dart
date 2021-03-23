import 'package:json_annotation/json_annotation.dart';
import 'package:synopsys_detect_app/bdio/model/dependency.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry {
  @JsonKey(name: "@id")
  final String id;
  @JsonKey(name: "@graph")
  final List<Dependency> dependencies;

  Entry(this.id, this.dependencies);

  // Person({required this.firstName, required this.lastName, this.dateOfBirth});
  //   factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  //   Map<String, dynamic> toJson() => _$PersonToJson(this);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);
  // : id = json["@id"],
  //   dependencies = (json["@graph"] as List).map((graphEntryJson) => Dependency.fromJson(graphEntryJson)).toList();
}
