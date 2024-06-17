import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_viewmodel.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/AddToDoBottomSheet/add_todo_screen.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';

class ToDoScreen extends StatelessWidget {
  final TodoListViewModel todoVM = Get.put(TodoListViewModel());
  final TextEditingController _searchController = TextEditingController();
  final SignInViewModel viewmodel = SignInViewModel();

  ToDoScreen({super.key});

  void _showAddTodoBottomSheet(BuildContext context, {Todo? todo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddTodoScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: AppColors.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Obx(() {
            return todoVM.isSearching.value
                ? TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search TODOs',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.textFieldUnderlineColor),
                      ),
                    ),
                    onChanged: (query) {
                      todoVM.searchQuery.value = query;
                      todoVM.searchTodos(query);
                    },
                  )
                : const Text(
                    "Plantist",
                    style: TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w700),
                  );
          }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              color: AppColors.textPrimaryColor,
              iconSize: 36,
              icon: Obx(() {
                return Icon(todoVM.isSearching.value
                    ? Icons.close_rounded
                    : Icons.search_rounded);
              }),
              onPressed: () {
                todoVM.toggleSearch();
                if (!todoVM.isSearching.value) {
                  _searchController.clear();
                  todoVM.searchTodos(''); // Clear search results
                }
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (todoVM.filteredTodos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You haven't added any TODOs yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap the button below to add a TODO.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              Map<String, List<Todo>> groupedTodos = {};
              for (var todo in todoVM.filteredTodos) {
                String dateKey = todoVM.formatDate(todo.dueDate);
                if (!groupedTodos.containsKey(dateKey)) {
                  groupedTodos[dateKey] = [];
                }
                groupedTodos[dateKey]!.add(todo);
              }
              return ListView(
                children: groupedTodos.keys.map((dateKey) {
                  List<Todo> todos = groupedTodos[dateKey]!;
                  todos.sort((a, b) => a.priority.compareTo(b.priority));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 16, right: 16),
                        child: Text(
                          dateKey,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondaryColor),
                        ),
                      ),
                      ...todos.map((todo) {
                        return Slidable(
                          key: Key(todo.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _showAddTodoBottomSheet(context, todo: todo);
                                },
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  todoVM.deleteTodo(todo.id);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: ListTile(
                              title: Text(
                                todo.title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textPrimaryColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(todo.category,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.textSecondaryColor)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  if (todo.attachment != null)
                                    const Text("1 Attachment"),
                                  const Divider()
                                ],
                              ),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: todo.priority == 1
                                            ? Colors.redAccent
                                            : todo.priority == 2
                                                ? Colors.orangeAccent
                                                : todo.priority == 3
                                                    ? Colors.blueAccent
                                                    : Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: todo.priority == 1
                                            ? Colors.red.withOpacity(0.1)
                                            : todo.priority == 2
                                                ? Colors.orange.withOpacity(0.1)
                                                : todo.priority == 3
                                                    ? Colors.blue
                                                        .withOpacity(0.1)
                                                    : Colors.grey
                                                        .withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        DateFormat('dd.MM.yyyy')
                                            .format(todo.dueDate),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                AppColors.textSecondaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              );
            }
          }),
          Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  TextButton(
                      onPressed: () => viewmodel.signOut(),
                      child: const Text("Sign Out")),
                  CustomWideButton(
                    onPressed: () => _showAddTodoBottomSheet(context),
                    icon: Icons.add_rounded,
                    text: "New Reminder",
                    backgroundColor: AppColors.enabledButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
