import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Screen/ToDoFlow/AddToDoFlow/add_todo_viewmodel.dart';
import 'package:plantist_app_/Utils/screen_util.dart';

class AddTodoDetailsScreen extends StatelessWidget {
  final String title;
  final String note;

  const AddTodoDetailsScreen(
      {super.key, required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    final AddTodoViewModel viewModel = Get.put(AddTodoViewModel());

    return SizedBox(
      height: ScreenUtil.screenHeightPercentage(context, 0.9),
      child: SingleChildScrollView(
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
                  onPressed: () => viewModel.saveTodo(title, note),
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
                      if (viewModel.selectedDate.value != null)
                        ListTile(
                          title: Text(DateFormat('MMMM d, yyyy')
                              .format(viewModel.selectedDate.value!)),
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
                              viewModel.setTime(TimeOfDay(
                                  hour: newTime.hour, minute: newTime.minute));
                            },
                            initialDateTime: DateTime(
                                0,
                                0,
                                0,
                                viewModel.selectedTime.value?.hour ?? 0,
                                viewModel.selectedTime.value?.minute ?? 0),
                          ),
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
                                    viewModel.category.value = index;
                                  },
                                  scrollController: FixedExtentScrollController(
                                    initialItem: viewModel.category.value,
                                  ),
                                  children: viewModel.categoryList
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
                      value: viewModel.categoryList[viewModel.category.value],
                    )),
              ),
              const DetailsContainerWidget(
                title: "Attach a file",
                icon: Icons.attach_file,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                  hintText: "Add Tags",
                  controller: viewModel.tagController,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (viewModel.tagController.text.isNotEmpty) {
                        viewModel.addTag(viewModel.tagController.text);
                      }
                    },
                  ),
                  onSubmitted: (tag) {
                    if (tag.isNotEmpty) {
                      viewModel.addTag(tag);
                    }
                  },
                ),
              ),
              Obx(() => Wrap(
                    spacing: 8.0,
                    children: viewModel.tags.map((tag) {
                      return InputChip(
                        label: Text(tag),
                        onDeleted: () => viewModel.removeTag(tag),
                      );
                    }).toList(),
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
                      fontWeight: FontWeight.normal),
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

void _showAddTodoDetailsBottomSheet(
    BuildContext context, String title, String note) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SizedBox(
        child: AddTodoDetailsScreen(title: title, note: note),
      );
    },
  );
}
