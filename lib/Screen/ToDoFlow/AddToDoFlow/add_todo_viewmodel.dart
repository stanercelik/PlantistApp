import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';
import 'package:textfield_tags/textfield_tags.dart';

enum Priority { high, medium, low, none }

class AddTodoViewModel extends GetxController {
  final TodoListViewModel todoController = Get.find();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final StringTagController stringTagController = StringTagController();
  final tags = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final dateSwitch = false.obs;
  final timeSwitch = false.obs;
  final priority = Priority.none.obs;
  final category = 0.obs;

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

  void saveTodo(String title, String note) {
    if (!isFormValid()) {
      Get.snackbar("Error", "Please fill in all fields: ${missingFields()}",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Map<String, dynamic> todoData = {
      'title': title,
      'note': note,
      'priority': priorityToString(priority.value),
      'dueDate': selectedDate.value ?? DateTime.now(),
      'dueTime': selectedTime.value != null
          ? '${selectedTime.value!.hour}:${selectedTime.value!.minute}'
          : null,
      'category': categoryList[category.value],
      'tags': tags,
      'attachment': null,
    };

    todoController.addTodo(todoData).then((value) {
      todoController.fetchTodos();
      Get.back();
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
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

  @override
  void onClose() {
    super.onClose();
    clearAllFields();
  }
}
