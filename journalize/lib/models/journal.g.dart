// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journal _$JournalFromJson(Map<String, dynamic> json) {
  return Journal(
    title: json['title'] as String,
    content: json['content'] as String,
    editDate: json['editDate'] == null
        ? null
        : DateTime.parse(json['editDate'] as String),
  );
}

Map<String, dynamic> _$JournalToJson(Journal instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'editDate': instance.editDate?.toIso8601String(),
    };
