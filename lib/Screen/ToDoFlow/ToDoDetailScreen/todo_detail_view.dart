import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/title_content_row_widget.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Model/todo_model.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoDetailScreen/todo_detail_viewmodel.dart';
import 'package:plantist_app_/Services/storage_service.dart';

class ToDoDetailScreen extends StatelessWidget {
  final ToDoDetailViewModel toDoDetailVM = Get.put(ToDoDetailViewModel());
  final StorageService _storageService = StorageService();

  ToDoDetailScreen({Key? key}) : super(key: key);

  Future<String> _getAttachmentUrl(String gsPath) async {
    try {
      String path =
          gsPath.replaceFirst('gs://your-bucket-name.appspot.com/', '');
      String downloadUrl = await _storageService.getDownloadUrl(path);
      return downloadUrl;
    } catch (e) {
      throw Exception('Error getting download URL: $e');
    }
  }

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
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          Todo todo = toDoDetailVM.todo.value;
          return SingleChildScrollView(
            child: Column(
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
                  const Text(
                    "Attachment:",
                    style: TextStyle(
                      color: AppColors.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _getAttachmentUrl(todo.attachment!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Could not load attachment');
                      } else if (!snapshot.hasData) {
                        return const Text('No attachment found');
                      } else {
                        String attachmentUrl = snapshot.data!;
                        return _buildAttachment(attachmentUrl);
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAttachment(String attachmentUrl) {
    if (attachmentUrl.endsWith('.jpg') ||
        attachmentUrl.endsWith('.jpeg') ||
        attachmentUrl.endsWith('.png') ||
        attachmentUrl.endsWith('.gif')) {
      return Image.network(
        attachmentUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'Could not load image',
            style: TextStyle(color: Colors.red),
          );
        },
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          _downloadFile(attachmentUrl);
        },
        icon: const Icon(Icons.download),
        label: const Text("Download Attachment"),
      );
    }
  }

  void _downloadFile(String url) async {}
}
