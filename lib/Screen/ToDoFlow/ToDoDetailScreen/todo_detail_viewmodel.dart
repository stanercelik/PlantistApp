import 'package:get/get.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_flow_viewmodel.dart';

class ToDoDetailViewModel extends GetxController {
  final Rx<Todo> todo = Rx<Todo>(Todo(
    id: '',
    title: '',
    note: '',
    priority: Priority.none,
    dueDate: DateTime.now(),
    dueTime: null,
    category: '',
    tags: [],
    attachment: null,
  ));

  void setTodoDetail(Todo selectedTodo) {
    todo.value = selectedTodo;
  }
}
