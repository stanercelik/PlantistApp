import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Model/todo_model.dart';

class TodoListViewModel extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Todo> todos = RxList<Todo>();
  RxList<Todo> filteredTodos = RxList<Todo>();
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    todos.bindStream(getTodos());
    filteredTodos.bindStream(getTodos());
    debounce(searchQuery, (_) => searchTodos(searchQuery.value),
        time: const Duration(milliseconds: 300));
  }

  Stream<List<Todo>> getTodos() {
    return firestore.collection('todos').snapshots().map((QuerySnapshot query) {
      List<Todo> retVal = [];
      for (var element in query.docs) {
        retVal.add(Todo.fromMap(element.data() as Map<String, dynamic>));
      }
      retVal.sort((a, b) => a.priority.compareTo(b.priority));
      return retVal;
    });
  }

  Future<void> addTodo(Todo todo) async {
    try {
      DocumentReference docRef =
          await firestore.collection('todos').add(todo.toMap());
      todo.id = docRef.id;
      await updateTodo(todo);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await firestore.collection('todos').doc(todo.id).update(todo.toMap());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await firestore.collection('todos').doc(id).delete();
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
