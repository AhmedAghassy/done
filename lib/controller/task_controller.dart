import 'package:done/db/db.dart';
import 'package:done/models/task_model.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final RxList<TaskModel> taskList = const <TaskModel>[].obs;

  Future<void> queryTasks() async {
    final List<Map<String, dynamic>> _queryTasks = await Db.queryDb();
    taskList.assignAll(
      _queryTasks.map((json) => TaskModel.fromJson(json)).toList(),
    );
  }

  Future<int> insertTask(TaskModel task) async {
    return await Db.insertDb(task);
  }

  Future<void> deleteAllTasks() async {
    await Db.deleteAllDb();
    queryTasks();
  }

  Future<void> deleteSingleTask(int id) async {
    await Db.deleteSingleDb(id);
    queryTasks();
  }

  Future<void> updateToComplete(int id) async {
    await Db.updateToCompletedDb(id);
    queryTasks();
  }
}
