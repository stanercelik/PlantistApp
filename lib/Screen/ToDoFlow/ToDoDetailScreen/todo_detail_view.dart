import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/title_content_row_widget.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoDetailScreen/todo_detail_viewmodel.dart';

class ToDoDetailScreen extends StatelessWidget {
  final ToDoDetailViewModel toDoDetailVM = Get.put(ToDoDetailViewModel());

  ToDoDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'TODO Details',
          style: TextStyle(
            color: AppColors.textPrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          Todo todo = toDoDetailVM.todo.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleContentRow(
                title: "Title:",
                content: todo.title,
              ),
              const SizedBox(height: 16),
              TitleContentRow(
                title: "Note:",
                content: todo.note,
              ),
              const SizedBox(height: 16),
              TitleContentRow(
                title: "Priority:",
                content: priorityToString(todo.priority),
              ),
              const SizedBox(height: 16),
              TitleContentRow(
                title: "Due Date:",
                content: todo.dueDate.toLocal().toString().split(' ')[0],
              ),
              if (todo.dueTime != null)
                TitleContentRow(
                  title: "Due Time:",
                  content: todo.dueTime!.format(context),
                ),
              const SizedBox(height: 16),
              TitleContentRow(
                title: "Category:",
                content: todo.category,
              ),
              const SizedBox(height: 16),
              TitleContentRow(
                title: "Tags:",
                content: todo.tags.join(', '),
              ),
              if (todo.attachment != null) ...[
                const SizedBox(height: 16),
                TitleContentRow(
                  title: "Attachment:",
                  content: todo.attachment,
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
