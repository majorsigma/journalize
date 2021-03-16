// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalList _$JournalListFromJson(Map<String, dynamic> json) {
  return JournalList(
    journalList: (json['journalList'] as List)
        ?.map((e) =>
            e == null ? null : Journal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$JournalListToJson(JournalList instance) =>
    <String, dynamic>{
      'journalList': instance.journalList?.map((e) => e?.toJson())?.toList(),
    };
