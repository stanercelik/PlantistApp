import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/AddToDoDetailBottomSheet/add_todo_details_viewmodel.dart';

class AddTodoDetailsScreen extends StatelessWidget {
  final String title;
  final String note;

  const AddTodoDetailsScreen(
      {super.key, required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    final TodoDetailsViewModel viewModel = Get.put(TodoDetailsViewModel());

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                      "Details",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () => viewModel.saveTodo(title, note),
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
              ),
              Obx(() => ListTile(
                    leading:
                        const Icon(Icons.calendar_today, color: Colors.red),
                    title: const Text("Date"),
                    trailing: Switch(
                      value: viewModel.dateSwitch.value,
                      onChanged: (value) {
                        viewModel.dateSwitch.value = value;
                        if (!value) {
                          viewModel.selectedDate.value = null;
                        }
                      },
                    ),
                  )),
              Obx(() {
                if (viewModel.dateSwitch.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        CalendarDatePicker(
                          initialDate:
                              viewModel.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          onDateChanged: (date) => viewModel.setDate(date),
                        ),
                        if (viewModel.selectedDate.value != null)
                          ListTile(
                            title: Text(DateFormat('MMMM d, yyyy')
                                .format(viewModel.selectedDate.value!)),
                          ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
              Obx(() => ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blue),
                    title: const Text("Time"),
                    trailing: Switch(
                      value: viewModel.timeSwitch.value,
                      onChanged: (value) {
                        viewModel.timeSwitch.value = value;
                        if (!value) {
                          viewModel.selectedTime.value = null;
                        }
                      },
                    ),
                  )),
              Obx(() {
                if (viewModel.timeSwitch.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: viewModel.selectedTime.value ??
                                  TimeOfDay.now(),
                            );
                            if (picked != null &&
                                picked != viewModel.selectedTime.value) {
                              viewModel.setTime(picked);
                            }
                          },
                          child: const Text("Select Time"),
                        ),
                        if (viewModel.selectedTime.value != null)
                          ListTile(
                            title: Text(
                                viewModel.selectedTime.value!.format(context)),
                          ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
              Obx(() => ListTile(
                    title: const Text("Priority"),
                    trailing: DropdownButton<int>(
                      value: viewModel.priority.value,
                      items: const [
                        DropdownMenuItem(
                            value: 1, child: Text("High Priority (Red)")),
                        DropdownMenuItem(
                            value: 2, child: Text("Medium Priority (Orange)")),
                        DropdownMenuItem(
                            value: 3, child: Text("Low Priority (Blue)")),
                        DropdownMenuItem(
                            value: 4, child: Text("No Priority (White)")),
                      ],
                      onChanged: (value) {
                        viewModel.priority.value = value!;
                      },
                      hint: const Text("Select Priority"),
                    ),
                  )),
              const ListTile(
                title: Text("Attach a file"),
                trailing: Icon(Icons.attach_file),
              ),
              TextField(
                controller: viewModel.categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: viewModel.tagController,
                decoration: const InputDecoration(labelText: "Tags"),
                onSubmitted: viewModel.addTag,
              ),
              Obx(() => Wrap(
                    children: viewModel.tags
                        .map((tag) => Chip(
                            label: Text(tag),
                            onDeleted: () => viewModel.removeTag(tag)))
                        .toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

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
