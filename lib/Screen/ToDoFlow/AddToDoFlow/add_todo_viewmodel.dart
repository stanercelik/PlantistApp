import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';
import 'package:timezone/data/latest.dart' as tz;

enum Priority { high, medium, low, none }

class AddTodoViewModel extends GetxController {
  final TodoListViewModel todoController = Get.find();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final tags = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final dateSwitch = false.obs;
  final timeSwitch = false.obs;
  final priority = Priority.none.obs;
  final category = 0.obs;
  final attachment = Rxn<dynamic>();
  String? todoId;

  final categoryList = [
    "Work",
    "Personal",
    "Health",
    "Education",
    "Finance",
    "Social",
    "Home",
    "Tech",
    "Shopping",
    "Projects",
    "Hobby",
    "Travel",
    "Creativity",
    "Others",
  ];

  void setDate(DateTime date) {
    selectedDate.value = date;
    updateFormValidState();
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
    updateFormValidState();
  }

  void addTag(String tag) {
    tags.add(tag);
    tagController.clear();
    updateFormValidState();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    updateFormValidState();
  }

  void setPriority(Priority newPriority) {
    priority.value = newPriority;
    updateFormValidState();
  }

  String getPriorityName() {
    switch (priority.value) {
      case Priority.high:
        return "High Priority";
      case Priority.medium:
        return "Medium Priority";
      case Priority.low:
        return "Low Priority";
      case Priority.none:
      default:
        return "No Priority";
    }
  }

  void saveTodo() async {
    if (!isFormValid()) {
      Get.snackbar("Error", "Please fill in all fields: ${missingFields()}",
          snackPosition: SnackPosition.TOP);
      return;
    }

    Todo todo = Todo(
      id: todoId ?? UniqueKey().toString(),
      title: titleController.text,
      note: noteController.text,
      priority: priority.value,
      dueDate: selectedDate.value ?? DateTime.now(),
      dueTime: selectedTime.value,
      category: categoryList[category.value],
      tags: tags,
      attachment: attachment.value,
    );

    if (todoId == null) {
      // New Todo
      todoController.addTodo(todo.toMap()).then((value) {
        _scheduleNotifications(todo);
        todoController.fetchTodos();
        Get.back();
      }).catchError((error) {
        Get.snackbar("Error", error.toString());
      });
    } else {
      // Existing Todo - Update
      final existingDoc = await todoController.getTodoDocument(todo.id);
      if (existingDoc.exists) {
        todoController.updateTodo(todo.id, todo.toMap()).then((value) {
          _scheduleNotifications(todo);
          todoController.fetchTodos();
          Get.back();
        }).catchError((error) {
          Get.snackbar("Error", error.toString());
        });
      } else {
        Get.snackbar("Error", "Document not found",
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  void clearAllFields() {
    titleController.clear();
    noteController.clear();
    tagController.clear();
    tags.clear();
    selectedDate.value = null;
    selectedTime.value = null;
    dateSwitch.value = false;
    timeSwitch.value = false;
    priority.value = Priority.none;
    category.value = 0;
    attachment.value = null;
    todoId = null;
  }

  bool isFormValid() {
    return titleController.text.isNotEmpty &&
        noteController.text.isNotEmpty &&
        selectedDate.value != null &&
        tags.isNotEmpty;
  }

  String missingFields() {
    List<String> missing = [];
    if (titleController.text.isEmpty) missing.add("Title");
    if (noteController.text.isEmpty) missing.add("Note");
    if (selectedDate.value == null) missing.add("Due Date");
    if (tags.isEmpty) missing.add("Tags");
    return missing.join(", ");
  }

  void updateFormValidState() {
    update();
  }

  void _scheduleNotifications(Todo todo) {
    tz.initializeTimeZones();

    DateTime dueDateTime = DateTime(
      todo.dueDate.year,
      todo.dueDate.month,
      todo.dueDate.day,
      todo.dueTime?.hour ?? 0,
      todo.dueTime?.minute ?? 0,
    );
    NotificationHelper.scheduleNotification(
      id: todo.id.hashCode,
      title: "Reminder: ${todo.title}",
      body: "Your TODO is due is now.",
      scheduledDateTime: dueDateTime,
    );
  }

  @override
  void onClose() {
    super.onClose();
    clearAllFields();
  }
}
