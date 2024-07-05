import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_flow_viewmodel.dart';
import 'package:plantist_app_/Utils/screen_util.dart';

class AddTodoDetailsScreen extends StatelessWidget {
  final Todo? todo;

  const AddTodoDetailsScreen({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    final AddTodoViewModel viewModel = Get.put(AddTodoViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (todo != null) {
        viewModel.todoId = todo!.id;
        viewModel.titleController.text = todo!.title;
        viewModel.noteController.text = todo!.note;
        viewModel.setPriority(todo!.priority);
        viewModel.selectedDate.value = todo!.dueDate;
        viewModel.dateSwitch.value = true;
        viewModel.selectedTime.value = todo!.dueTime;
        viewModel.timeSwitch.value = todo!.dueTime != null;
        viewModel.category.value =
            viewModel.categoryList.indexOf(todo!.category);
        viewModel.tags.assignAll(todo!.tags);
        viewModel.attachmentUrl.value = todo!.attachment;
      }
    });

    return SizedBox(
      height: ScreenUtil.screenHeightPercentage(context, 0.9),
      child: SingleChildScrollView(
        controller: viewModel.scrollController,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoNavigationBar(
                middle: const Text(
                  'Details',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                  onPressed: () => viewModel.saveTodo(),
                  child: Text(
                    todo != null ? "Update" : "Add",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: !viewModel.isFormValid()
                          ? CupertinoColors.systemGrey
                          : CupertinoColors.systemBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() => ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: const Text(
                      "Date",
                      style: TextStyle(
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 19),
                    ),
                    subtitle: viewModel.dateSwitch.value &&
                            viewModel.selectedDate.value != null
                        ? Text(
                            viewModel.getFormattedDate(
                                viewModel.selectedDate.value!),
                            style: const TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : null,
                    trailing: CupertinoSwitch(
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
                  return Column(
                    children: [
                      CalendarDatePicker(
                        initialDate:
                            viewModel.selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        onDateChanged: (date) => viewModel.setDate(date),
                      ),
                    ],
                  );
                }
                return Container();
              }),
              const Divider(),
              Obx(() => ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: const Text(
                      "Time",
                      style: TextStyle(
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                    subtitle: viewModel.timeSwitch.value &&
                            viewModel.selectedTime.value != null
                        ? Text(
                            viewModel.selectedTime.value!.format(context),
                            style: const TextStyle(
                              color: AppColors.textSecondaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : null,
                    trailing: CupertinoSwitch(
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
                        SizedBox(
                          height: 150,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (DateTime newTime) {
                              final now = DateTime.now();
                              if (viewModel.selectedDate.value != null) {
                                final selectedDate =
                                    viewModel.selectedDate.value!;
                                final selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  newTime.hour,
                                  newTime.minute,
                                );

                                if (selectedDate.isAtSameMomentAs(
                                    DateTime(now.year, now.month, now.day))) {
                                  if (selectedDateTime.isAfter(now)) {
                                    viewModel.setTime(TimeOfDay(
                                      hour: newTime.hour,
                                      minute: newTime.minute,
                                    ));
                                  }
                                } else {
                                  viewModel.setTime(TimeOfDay(
                                    hour: newTime.hour,
                                    minute: newTime.minute,
                                  ));
                                }
                              } else {
                                viewModel.setTime(TimeOfDay(
                                  hour: newTime.hour,
                                  minute: newTime.minute,
                                ));
                              }
                            },
                            initialDateTime: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              viewModel.selectedTime.value?.hour ??
                                  TimeOfDay.now().hour,
                              viewModel.selectedTime.value?.minute ??
                                  TimeOfDay.now().minute,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Obx(
                        () => Container(
                          decoration: const BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(16),
                                topEnd: Radius.circular(16),
                              )),
                          height:
                              ScreenUtil.screenHeightPercentage(context, 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  itemExtent: 36.0,
                                  onSelectedItemChanged: (int index) {
                                    viewModel
                                        .setPriority(Priority.values[index]);
                                  },
                                  scrollController: FixedExtentScrollController(
                                    initialItem: viewModel.priority.value.index,
                                  ),
                                  children: [
                                    const PickerRowWidget(
                                      text: "High Priority",
                                      color: Colors.redAccent,
                                    ),
                                    const PickerRowWidget(
                                      text: "Medium Priority",
                                      color: Colors.orangeAccent,
                                    ),
                                    const PickerRowWidget(
                                      text: "Low Priority",
                                      color: Colors.blueAccent,
                                    ),
                                    PickerRowWidget(
                                      text: "No Priority",
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                        color: AppColors.textBlueColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Obx(() => DetailsContainerWidget(
                      title: "Priority",
                      value: viewModel.getPriorityName(),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Obx(
                        () => Container(
                          decoration: const BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(16),
                                topEnd: Radius.circular(16),
                              )),
                          height:
                              ScreenUtil.screenHeightPercentage(context, 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 150,
                                child: CupertinoPicker(
                                  itemExtent: 36.0,
                                  onSelectedItemChanged: (int index) {
                                    viewModel.category.value = index + 1;
                                  },
                                  scrollController: FixedExtentScrollController(
                                    initialItem: viewModel.category.value - 1,
                                  ),
                                  children: viewModel.categoryList
                                      .skip(1)
                                      .map((category) => PickerRowWidget(
                                            text: category,
                                          ))
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                        color: AppColors.textBlueColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Obx(() => DetailsContainerWidget(
                      title: "Category",
                      value: viewModel.selectedCategory,
                    )),
              ),
              Obx(() {
                if (viewModel.attachment.value != null) {
                  return const DetailsContainerWidget(
                    title: "Attachment",
                    value: "Attached",
                    icon: Icons.attach_file,
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      await viewModel.pickFile();
                    },
                    child: const DetailsContainerWidget(
                      title: "Attach a file",
                      icon: Icons.attach_file,
                    ),
                  );
                }
              }),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 12),
                child: CustomTextField(
                  hintText: "Add Tags",
                  controller: viewModel.tagController,
                  focusNode: viewModel.tagFocusNode,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      viewModel.addTag(viewModel.tagController.text);
                    },
                  ),
                  onSubmitted: (tag) {
                    viewModel.addTag(tag);
                    FocusScope.of(context).requestFocus(viewModel.tagFocusNode);
                  },
                ),
              ),
              Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: ScreenUtil.screenWidth(context),
                      child: Wrap(
                        spacing: 8.0,
                        children: viewModel.tags.map((tag) {
                          return InputChip(
                            label: Text(tag),
                            onDeleted: () => viewModel.removeTag(tag),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsContainerWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DetailsContainerWidget({
    super.key,
    required this.title,
    this.value = "None",
    this.icon = Icons.arrow_forward_ios_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.5))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                      color: AppColors.textSecondaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  icon,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class PickerRowWidget extends StatelessWidget {
  final String text;
  final Color? color;

  const PickerRowWidget({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(
          width: 8,
        ),
        color == null
            ? const SizedBox()
            : Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color!,
                    width: 2.0,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color!.withOpacity(0.1)),
                ),
              ),
      ],
    );
  }
}
