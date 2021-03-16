import 'package:flutter/foundation.dart';
import 'package:journalize/models/journal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_list.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalList {
  @required
  List<Journal> journalList;

  JournalList({this.journalList});

  factory JournalList.fromJson({Map<String, dynamic> json}) =>
      _$JournalListFromJson(json);

  Map<String, dynamic> toJson() => _$JournalListToJson(this);

}
