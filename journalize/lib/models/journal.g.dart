// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journal _$JournalFromJson(Map<String, dynamic> json) {
  return Journal(
    title: json['title'] as String,
    content: json['content'] as String,
    category: json['category'] as String,
    editDate: json['editDate'] as String,
  );
}

Map<String, dynamic> _$JournalToJson(Journal instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'editDate': instance.editDate,
    };
