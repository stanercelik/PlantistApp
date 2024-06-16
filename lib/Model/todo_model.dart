import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String note;
  int priority; // 1 = High (Red), 2 = Medium (Orange), 3 = Low (Blue), 4 = None (White)
  DateTime dueDate;
  String category;
  List<String> tags;
  String? attachment;

  Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.tags,
    this.attachment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'priority': priority,
      'dueDate': dueDate,
      'category': category,
      'tags': tags,
      'attachment': attachment,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      priority: map['priority'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      category: map['category'],
      tags: List<String>.from(map['tags']),
      attachment: map['attachment'],
    );
  }
}
