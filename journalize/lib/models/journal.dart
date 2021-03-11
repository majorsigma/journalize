import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal.g.dart';

@JsonSerializable()
class Journal {
  @required String title;
  @required String content;
  @required String category;
  @required String editDate;

  Journal({this.title, this.content, this.category, this.editDate});

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);

  Map<String, dynamic> toJson() => _$JournalToJson(this);
}
