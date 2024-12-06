import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          if (controller.tasks.isEmpty) {
            return const Text(
              'No tasks yet. Add some!',
              style: TextStyle(fontSize: 20),
            );
          } else {
            return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final task = controller.tasks[index];
                return ListTile(
                  title: Text(task['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteTask(task['id']);
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: _addTaskButton(context),
    );
  }

  Widget _addTaskButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAddTaskDialog(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String? taskName;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          onChanged: (value) {
            taskName = value;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter task name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskName != null && taskName!.isNotEmpty) {
                controller.addTask(taskName!);
                Navigator.of(context).pop(); 
              } else {
                Get.snackbar('Error', 'Task name cannot be empty');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
