import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';
import 'package:plantist_app_/Utils/permission_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:path/path.dart' as p;

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
  final attachment = Rxn<File>();
  final attachmentUrl = Rxn<String>();
  final ScrollController scrollController = ScrollController();
  final FocusNode tagFocusNode = FocusNode();
  String? todoId;

  final categoryList = [
    "None",
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

  String get selectedCategory =>
      category.value == 0 ? "None" : categoryList[category.value];

  @override
  void onInit() {
    super.onInit();
    tagFocusNode.addListener(_scrollToBottom);
    tagController.addListener(() {
      if (tagController.text.endsWith('\n')) {
        addTag(tagController.text.trim());
        tagController.clear();
      }
    });
  }

  void _scrollToBottom() {
    if (tagFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    updateFormValidState();
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
    updateFormValidState();
  }

  void addTag(String tag) {
    if (tags.length < 5 && tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagController.clear();
      updateFormValidState();
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else if (tags.length >= 5) {
      Get.snackbar("Limit reached", "You can only add up to 5 tags.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
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

  Future<void> pickFile() async {
    await PermissionHelper.requestPermissions();

    if (await Permission.storage.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        attachment.value = File(pickedFile.path);
      }
    } else {
      Get.snackbar("Permission Required",
          "Storage permission is required to select files.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> uploadFile(String todoId) async {
    if (attachment.value != null) {
      final fileName = p.basename(attachment.value!.path);
      final path =
          'todos/${FirebaseAuth.instance.currentUser!.uid}/$todoId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(attachment.value!);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      attachmentUrl.value = url;
    }
  }

  void saveTodo() async {
    if (!isFormValid()) {
      Get.snackbar(
        "Error",
        "Please fill in all fields: ${missingFields()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final todoIdForFile = todoId ?? UniqueKey().toString();
    if (attachment.value != null && attachmentUrl.value == null) {
      await uploadFile(todoIdForFile);
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
      attachment: attachmentUrl.value,
    );

    if (todoId == null) {
      // New Todo
      todoController.addTodo(todo.toMap()).then((value) {
        clearAllFields();
        _scheduleNotifications(todo);
        todoController.fetchTodos();
        Get.back();
      }).catchError((error) {
        Get.snackbar("Error", error.toString());
      });
    } else {
      // Update
      try {
        final existingDoc = await todoController.getTodoDocument(todo.id);
        if (existingDoc.exists) {
          await todoController.updateTodo(todo.id, todo.toMap());
          _scheduleNotifications(todo);
          todoController.fetchTodos();
          Get.back();
        } else {
          Get.snackbar("Error", "Document not found",
              snackPosition: SnackPosition.TOP);
        }
      } catch (error) {
        Get.snackbar("Error", error.toString());
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
    tagFocusNode.removeListener(_scrollToBottom);
    clearAllFields();
  }

  String getFormattedDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (date.isAtSameMomentAs(today)) {
      return "Today";
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return "Tomorrow";
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
}
