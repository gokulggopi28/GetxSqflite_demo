import 'package:get/get.dart';

import '../../../services/database_service.dart';

class HomeController extends GetxController {
  final tasks = <Map<String, dynamic>>[].obs;
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final fetchedTasks = await _dbService.fetchItems();
    tasks.assignAll(fetchedTasks);
  }

  Future<void> addTask(String taskName) async {
    final newTask = {
      'content': taskName,
      'status': 0, //
    };
    await _dbService.insertItem(newTask);
    fetchTasks();
  }

  Future<void> deleteTask(int taskId) async {
    await _dbService.deleteItem(taskId);
    fetchTasks();
  }
}
