import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/AddToDoDetailBottomSheet/add_todo_details_bs.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_viewmodel.dart';

class AddTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddTodoScreen({super.key, this.todo});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final AddTodoViewModel viewModel = Get.put(AddTodoViewModel());

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      viewModel.titleController.text = widget.todo!.title;
      viewModel.noteController.text = widget.todo!.note;
      viewModel.setPriority(widget.todo!.priority);
      viewModel.selectedDate.value = widget.todo!.dueDate;
      viewModel.dateSwitch.value = true;
      viewModel.selectedTime.value = widget.todo!.dueTime;
      viewModel.timeSwitch.value = widget.todo!.dueTime != null;
      viewModel.category.value =
          viewModel.categoryList.indexOf(widget.todo!.category);
      viewModel.tags.assignAll(widget.todo!.tags);
      viewModel.attachment.value = widget.todo!.attachment;
    }
  }

  void _showAddTodoDetailsBottomSheet(BuildContext context, Todo? todo) {
    Get.back();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddTodoDetailsScreen(todo: todo),
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
            top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoNavigationBar(
              border: const Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              middle: const Text(
                "New Reminder",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
              ),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  viewModel.clearAllFields();
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: !viewModel.isFormValid()
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.systemBlue,
                  ),
                ),
                onPressed: () {
                  if (!viewModel.isFormValid()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Please fill in all fields: ${viewModel.missingFields()}"),
                      ),
                    );
                    return;
                  }

                  _showAddTodoDetailsBottomSheet(context, widget.todo);
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              controller: viewModel.titleController,
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
              controller: viewModel.noteController,
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
                _showAddTodoDetailsBottomSheet(context, widget.todo);
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
                                    fontSize: 19),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Today",
                                style: TextStyle(
                                    color: AppColors.textSecondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
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

void showAddTodoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const AddTodoScreen(),
  );
}
