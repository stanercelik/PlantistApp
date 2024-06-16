import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/AddToDoDetailBottomSheet/add_todo_details_bs.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_viewmodel.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TodoListViewModel todoController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _showAddTodoDetailsBottomSheet(
      BuildContext context, String title, String note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddTodoDetailsScreen(title: title, note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: AppColors.textBlueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const Text(
                  "New Reminder",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    // Show a dialog or a snackbar if title or note is missing
                    if (titleController.text.isEmpty ||
                        noteController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter title and note"),
                        ),
                      );
                      return;
                    }

                    _showAddTodoDetailsBottomSheet(
                        context, titleController.text, noteController.text);
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.disabledButtonColor),
                  ),
                ),
              ],
            ),
            CustomTextField(
              controller: titleController,
              hintText: "Title",
              showValidationIcon: false,
              borderStyle: InputBorder.none,
              disabledBorderStyle: InputBorder.none,
              hintStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.disabledButtonColor),
            ),
            const Divider(),
            CustomTextField(
              controller: noteController,
              hintText: "Notes",
              showValidationIcon: false,
              borderStyle: InputBorder.none,
              disabledBorderStyle: InputBorder.none,
              maxLine: 5,
              hintStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.disabledButtonColor),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to details screen
                _showAddTodoDetailsBottomSheet(
                    context, titleController.text, noteController.text);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(
                                    color: AppColors.textPrimaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                              Text(
                                "Today",
                                style: TextStyle(
                                    color: AppColors.textSecondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddTodoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const AddTodoScreen(),
  );
}
