import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_viewmodel.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/AddToDoBottomSheet/add_todo_view.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_flow_viewmodel.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoDetailScreen/todo_detail_view.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoDetailScreen/todo_detail_viewmodel.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';

class ToDoListScreen extends StatelessWidget {
  final TodoListViewModel todoVM = Get.put(TodoListViewModel());
  final TextEditingController _searchController = TextEditingController();
  final SignInViewModel viewmodel = SignInViewModel();

  ToDoListScreen({super.key});

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
                  todoVM.applyFilters();
                }
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: SizedBox(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Obx(() => _buildFilterButton(
                      context,
                      "Category",
                      todoVM.selectedCategory.value,
                      () => _showCategoryPicker(context),
                      () => todoVM.setCategory(todoVM.selectedCategory.value),
                      todoVM.selectedCategory.value.isNotEmpty)),
                  Obx(() => _buildFilterButton(
                      context,
                      "Date",
                      todoVM.selectedDate.value != null
                          ? DateFormat('dd.MM.yyyy')
                              .format(todoVM.selectedDate.value!)
                          : "",
                      () => _showDatePicker(context),
                      () => todoVM.setDate(todoVM.selectedDate.value),
                      todoVM.selectedDate.value != null)),
                  Obx(() => _buildFilterButton(
                      context,
                      "Priority",
                      todoVM.selectedPriority.value != null
                          ? priorityToString(todoVM.selectedPriority.value!)
                          : "",
                      () => _showPriorityPicker(context),
                      () => todoVM.setPriority(todoVM.selectedPriority.value),
                      todoVM.selectedPriority.value != null)),
                  Obx(() => _buildFilterButton(
                      context,
                      "Tags",
                      todoVM.selectedTags.isNotEmpty ? "Tags Selected" : "",
                      () => _showTagPicker(context),
                      () => todoVM.clearTags(),
                      todoVM.selectedTags.isNotEmpty)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
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
                    todos.sort(
                        (a, b) => a.priority.index.compareTo(b.priority.index));
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
                                    _showAddTodoBottomSheet(context,
                                        todo: todo);
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
                                            color:
                                                AppColors.textSecondaryColor)),
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
                                          color:
                                              getPriorityColor(todo.priority),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: getPriorityColor(todo.priority)
                                              .withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        if (todo.dueTime != null)
                                          Text(
                                            MaterialLocalizations.of(context)
                                                .formatTimeOfDay(todo.dueTime!),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors
                                                    .textSecondaryColor),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  ToDoDetailViewModel toDoDetailVM =
                                      Get.put(ToDoDetailViewModel());
                                  toDoDetailVM.setTodoDetail(todo);
                                  Get.to(() => ToDoDetailScreen());
                                },
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
          ),
          Column(
            children: [
              TextButton(
                  onPressed: () => viewmodel.signOut(),
                  child: const Text("sign out")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomWideButton(
                  onPressed: () => _showAddTodoBottomSheet(context),
                  icon: Icons.add_rounded,
                  text: "New Reminder",
                  backgroundColor: AppColors.enabledButtonColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      BuildContext context,
      String label,
      String selectedValue,
      VoidCallback onTap,
      VoidCallback onLongPress,
      bool isActive) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.enabledButtonColor
                : AppColors.disabledButtonColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              selectedValue.isEmpty ? label : selectedValue,
              style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: todoVM.todos
                  .map((todo) => todo.category)
                  .toSet()
                  .map((category) {
                return RadioListTile(
                  title: Text(category),
                  value: category,
                  groupValue: todoVM.selectedCategory.value,
                  onChanged: (value) {
                    todoVM.setCategory(value as String);
                    Get.back();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Clear"),
              onPressed: () {
                todoVM.setCategory('');
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTodoBottomSheet(BuildContext context, {Todo? todo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTodoScreen(todo: todo),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        todoVM.setDate(pickedDate);
      }
    });
  }

  void _showPriorityPicker(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(50.0, 100.0, 50.0, 100.0),
      items: Priority.values.map((priority) {
        return PopupMenuItem(
          value: priority,
          child: Text(priorityToString(priority)),
        );
      }).toList(),
    ).then((selectedPriority) {
      if (selectedPriority != null) {
        todoVM.setPriority(selectedPriority);
      }
    });
  }

  void _showTagPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Tags"),
          content: SizedBox(
            width: double.maxFinite,
            child: Obx(() {
              return ListView(
                children:
                    todoVM.todos.expand((todo) => todo.tags).toSet().map((tag) {
                  return Obx(() {
                    return CheckboxListTile(
                      title: Text(tag),
                      value: todoVM.selectedTags.contains(tag),
                      onChanged: (isSelected) {
                        todoVM.toggleTag(tag);
                      },
                    );
                  });
                }).toList(),
              );
            }),
          ),
          actions: [
            TextButton(
              child: const Text("Done"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}

Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Colors.redAccent;
    case Priority.medium:
      return Colors.orangeAccent;
    case Priority.low:
      return Colors.blueAccent;
    case Priority.none:
    default:
      return Colors.grey;
  }
}

String priorityToString(Priority priority) {
  switch (priority) {
    case Priority.high:
      return 'High';
    case Priority.medium:
      return 'Medium';
    case Priority.low:
      return 'Low';
    case Priority.none:
    default:
      return 'None';
  }
}
