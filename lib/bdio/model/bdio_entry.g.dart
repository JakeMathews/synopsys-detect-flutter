// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdio_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return Entry(
    json['@id'] as String,
    (json['@graph'] as List)
        ?.map((e) =>
            e == null ? null : Dependency.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      '@id': instance.id,
      '@graph': instance.dependencies,
    };
