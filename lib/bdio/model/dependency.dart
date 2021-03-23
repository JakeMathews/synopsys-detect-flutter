import 'package:json_annotation/json_annotation.dart';

part 'dependency.g.dart';

@JsonSerializable()
class Dependency {
  @JsonKey(name: "@id")
  final String id;

  Dependency(this.id);

  factory Dependency.fromJson(Map<String, dynamic> json) => _$DependencyFromJson(json);
  Map<String, dynamic> toJson() => _$DependencyToJson(this);
}
