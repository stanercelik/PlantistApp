import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_viewmodel.dart';

class Todo {
  final String id;
  final String title;
  final String note;
  final Priority priority;
  final DateTime dueDate;
  final TimeOfDay? dueTime;
  final String category;
  final List<String> tags;
  final dynamic attachment;

  Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    this.dueTime,
    required this.category,
    required this.tags,
    this.attachment,
  });

  factory Todo.fromMap(String id, Map<String, dynamic> data) {
    var priorityValue = data['priority'];
    String priorityString;

    if (priorityValue is int) {
      switch (priorityValue) {
        case 1:
          priorityString = 'high';
          break;
        case 2:
          priorityString = 'medium';
          break;
        case 3:
          priorityString = 'low';
          break;
        default:
          priorityString = 'none';
          break;
      }
    } else {
      priorityString = priorityValue ?? 'none';
    }

    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null || timeString.isEmpty) return null;
      final parts = timeString.split(":");
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return TimeOfDay(hour: hour, minute: minute);
    }

    return Todo(
      id: id,
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      priority: stringToPriority(priorityString),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      dueTime: parseTime(data['dueTime']),
      category: data['category'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      attachment: data['attachment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'priority': priorityToString(priority),
      'dueDate': dueDate,
      'dueTime': dueTime != null ? '${dueTime!.hour}:${dueTime!.minute}' : null,
      'category': category,
      'tags': tags,
      'attachment': attachment,
    };
  }
}

String priorityToString(Priority priority) {
  switch (priority) {
    case Priority.high:
      return 'high';
    case Priority.medium:
      return 'medium';
    case Priority.low:
      return 'low';
    case Priority.none:
    default:
      return 'none';
  }
}

Priority stringToPriority(String priorityString) {
  switch (priorityString) {
    case 'high':
      return Priority.high;
    case 'medium':
      return Priority.medium;
    case 'low':
      return Priority.low;
    case 'none':
    default:
      return Priority.none;
  }
}
