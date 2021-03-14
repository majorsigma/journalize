import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal.g.dart';

@JsonSerializable()
class Journal {
  @required String title;
  @required String content;
  @required DateTime editDate;

  Journal({this.title, this.content, this.editDate});

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);

  Map<String, dynamic> toJson() => _$JournalToJson(this);
}
