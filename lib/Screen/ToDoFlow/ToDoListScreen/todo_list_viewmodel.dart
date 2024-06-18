import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';

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
        Todo todo = Todo.fromMap(doc.id, data ?? {});
        return todo;
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
      print("Updating TODO: $updatedData");
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('todos')
            .doc(todoId)
            .set(updatedData, SetOptions(merge: true));
        print("Todo Updated Successfully");
        fetchTodos(); // Güncelleme sonrasında verileri tekrar çekiyoruz
      } catch (error) {
        print("Failed to update Todo: $error");
      }
    } else {
      print("User not logged in");
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
