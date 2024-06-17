import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Model/todo_model.dart';

class TodoListViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Todo> todos = RxList<Todo>();
  RxList<Todo> filteredTodos = RxList<Todo>();
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() {
    getUserTodos().listen((QuerySnapshot snapshot) {
      todos.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return Todo(
          id: doc.id,
          title: data?['title'] ?? '',
          note: data?['note'] ?? '',
          priority: data?['priority'] ?? 0,
          dueDate: (data?['dueDate'] as Timestamp).toDate(),
          category: data?['category'] ?? '',
          tags: List<String>.from(data?['tags'] ?? []),
          attachment: (data != null && data.containsKey('attachment'))
              ? data['attachment']
              : null,
        );
      }).toList();
      filteredTodos.assignAll(todos);
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

  Future<void> addTodo(Map<String, dynamic> todoData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .add(todoData);
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
    }
  }

  Future<void> updateTodo(
      String todoId, Map<String, dynamic> updatedData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todos')
          .doc(todoId)
          .update(updatedData);
    }
  }

  void searchTodos(String query) {
    if (query.isEmpty) {
      filteredTodos.assignAll(todos);
    } else {
      filteredTodos.assignAll(
        todos
            .where((todo) =>
                todo.title.toLowerCase().contains(query.toLowerCase()) ||
                todo.tags.any(
                    (tag) => tag.toLowerCase().contains(query.toLowerCase())))
            .toList(),
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
