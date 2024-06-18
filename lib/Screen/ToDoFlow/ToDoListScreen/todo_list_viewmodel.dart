import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_viewmodel.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';

class TodoListViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Todo> todos = RxList<Todo>();
  RxList<Todo> filteredTodos = RxList<Todo>();
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;
  RxString selectedCategory = ''.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<Priority?> selectedPriority = Rx<Priority?>(null);
  RxList<String> selectedTags = RxList<String>();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() {
    getUserTodos().listen((QuerySnapshot snapshot) {
      todos.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        Todo todo = Todo.fromMap(doc.id, data ?? {});
        return todo;
      }).toList();
      applyFilters();
    });
  }

  Stream<QuerySnapshot> getUserTodos() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .snapshots();
    } else {
      throw Exception("User not logged in");
    }
  }

  void applyFilters() {
    filteredTodos.assignAll(
      todos.where((todo) {
        bool matchesCategory = selectedCategory.value.isEmpty ||
            todo.category == selectedCategory.value;
        bool matchesDate = selectedDate.value == null ||
            isSameDate(todo.dueDate, selectedDate.value!);
        bool matchesPriority = selectedPriority.value == null ||
            todo.priority == selectedPriority.value;
        bool matchesTags = selectedTags.isEmpty ||
            selectedTags.every((tag) => todo.tags.contains(tag));
        bool matchesSearchQuery = searchQuery.value.isEmpty ||
            todo.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            todo.tags.any((tag) =>
                tag.toLowerCase().contains(searchQuery.value.toLowerCase()));
        return matchesCategory &&
            matchesDate &&
            matchesPriority &&
            matchesTags &&
            matchesSearchQuery;
      }).toList(),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void setCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    applyFilters();
    update();
  }

  void setDate(DateTime? date) {
    if (selectedDate.value != null &&
        date != null &&
        isSameDate(selectedDate.value!, date)) {
      selectedDate.value = null;
    } else {
      selectedDate.value = date;
    }
    applyFilters();
    update();
  }

  void setPriority(Priority? priority) {
    if (selectedPriority.value == priority) {
      selectedPriority.value = null;
    } else {
      selectedPriority.value = priority;
    }
    applyFilters();
    update();
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    applyFilters();
    update();
  }

  void clearTags() {
    selectedTags.clear();
    applyFilters();
    update();
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedDate.value = null;
    selectedPriority.value = null;
    selectedTags.clear();
    applyFilters();
    update();
  }

  Future<DocumentSnapshot> getTodoDocument(String todoId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(todoId)
          .get();
    } else {
      throw Exception("User not logged in");
    }
  }

  Future<void> addTodo(Map<String, dynamic> todoData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .add(todoData);
      fetchTodos();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(todoId)
          .delete();
      NotificationHelper.unScheduleNotification(todoId.hashCode);
    }
  }

  Future<void> updateTodo(
      String todoId, Map<String, dynamic> updatedData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('todos')
            .doc(todoId)
            .set(updatedData, SetOptions(merge: true));
        fetchTodos();
      } catch (error) {
        print("Failed to update Todo: $error");
      }
    } else {
      print("User not logged in");
    }
  }

  void searchTodos(String query) {
    if (query.isEmpty) {
      applyFilters();
    } else {
      filteredTodos.assignAll(
        todos.where((todo) {
          bool matchesTitle =
              todo.title.toLowerCase().contains(query.toLowerCase());
          bool matchesTags = todo.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
          return matchesTitle || matchesTags;
        }).toList(),
      );
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
      searchTodos('');
    }
  }

  String formatDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    if (DateFormat('dd.MM.yyyy').format(date) ==
        DateFormat('dd.MM.yyyy').format(today)) {
      return 'Today';
    } else if (DateFormat('dd.MM.yyyy').format(date) ==
        DateFormat('dd.MM.yyyy').format(tomorrow)) {
      return 'Tomorrow';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }
}
