import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';

class TodoDetailsViewModel extends GetxController {
  final TodoListViewModel todoController = Get.find();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final List<String> tags = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final dateSwitch = false.obs;
  final timeSwitch = false.obs;
  final priority = 4.obs;

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void addTag(String tag) {
    tags.add(tag);
    tagController.clear();
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  void saveTodo(String title, String note) {
    if (categoryController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a category",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Todo newTodo = Todo(
      id: '',
      title: title,
      note: note,
      priority: priority.value,
      dueDate: selectedDate.value ?? DateTime.now(),
      category: categoryController.text,
      tags: tags,
    );
    todoController.addTodo(newTodo);
    Get.back();
  }
}
