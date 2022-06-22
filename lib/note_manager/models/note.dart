import 'package:careshare/category_manager/domain/models/category.dart';

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class Note {
  final String id;
  String caregroupId;
  String title;
  CareCategory category;
  String? details;

  String createdById;
  DateTime createdDate;
  Document? content;
  String? link;

  Note({
    required this.id,
    required this.caregroupId,
    required this.title,
    required this.category,
    this.details,
    required this.createdById,
    required this.createdDate,
    this.content,
    this.link,
  });

  Note clone() {
    Note cloned = Note(
      id: id,
      caregroupId: caregroupId,
      title: title,
      category: category,
      details: details,
      createdById: createdById,
      createdDate: createdDate,
      content: content,
      link: link,
    );

    return cloned;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregroup': caregroupId,
      'title': title,
      'category': category.toJson(),
      'details': details,
      'from': createdById,
      'date_created': createdDate.toString(),
      'content': content!.toDelta().toJson(),
      'link': link,
    };
  }

  factory Note.fromJson(dynamic key, dynamic value) {
    final title = value['title'] ?? '';

    final details = value['details'] ?? '';

    Document contentMap;
    if (value['content'] != "") {
      contentMap = Document.fromJson(value['content']);
    } else {
      contentMap = Document()..insert(0, 'Empty asset');
    }

    return Note(
      id: key,
      caregroupId: value['caregroup'],
      title: title,
      category: CareCategory.fromJson(value['category']),
      details: details,
      createdById: value['from'],
      createdDate: DateTime.parse(value['date_created']),
      content: contentMap,
      link: value['link'] ?? "",
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.caregroupId == caregroupId &&
        other.title == title &&
        other.content!.toDelta().toJson() == content!.toDelta().toJson() &&
        other.category == category &&
        other.details == details &&
        other.createdById == createdById &&
        other.createdDate == createdDate &&
        other.link == link;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        caregroupId.hashCode ^
        title.hashCode ^
        category.hashCode ^
        details.hashCode ^
        createdById.hashCode ^
        createdDate.hashCode ^
        content.hashCode ^
        link.hashCode;
  }
}

enum NoteField {
  caregroupId,
  title,
  category,
  details,
  createdById,
  createdDate,
  content,
  link,
}
