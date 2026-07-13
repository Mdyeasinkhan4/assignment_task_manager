import 'dart:convert';
import 'package:flutter/material.dart';

import '../data/model/api_response.dart';
import '../data/model/task_model.dart';
import '../data/model/task_status_count_model.dart';
import '../data/service/api_caller.dart';
import '../utils/urls.dart';
import '../widget/task_card.dart';
import '../widget/task_count_by_status.dart';
import 'add_new_task_screen.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({super.key});

  @override
  State<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {

  final List<String> filters = ['All', 'New', 'Progress', 'Completed', 'Cancelled'];
  String selectedFilter = 'All';

  List<TaskStatusCountModel> taskCount = [];
  List<TaskModel> tasks = [];
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    getAllTaskCount();
    getTasks();
  }

  Future<void> getAllTaskCount() async {
    final ApiResponse response = await ApiCaller.getRequest(url: TMUrls.getTaskCountURL);

    List<TaskStatusCountModel> taskC = [];

    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in (response.responseData['data'])) {
        taskC.add(TaskStatusCountModel.fromJson(jsonData));
      }
      taskC.removeWhere((e) => e.sId == null);
    }

    setState(() { taskCount = taskC; });
  }

  Future<void> getTasks() async {
    setState(() { inProgress = true; });

    List<TaskModel> result = [];

    if (selectedFilter == 'All') {
      // backend-e ekta 'get all' endpoint nai, tai 4-ta status-er list ek shathe fetch kore merge korlam
      List<String> statuses = ['New', 'Progress', 'Completed', 'Cancelled'];

      List<ApiResponse> responses = await Future.wait(
        statuses.map((s) => ApiCaller.getRequest(url: TMUrls.getTaskByStatusURL(s))),
      );

      for (ApiResponse response in responses) {
        if (response.isSuccess) {
          for (Map<String, dynamic> jsonData in (response.responseData['data'])) {
            result.add(TaskModel.fromJson(jsonData));
          }
        }
      }
    } else {
      final ApiResponse response = await ApiCaller.getRequest(
        url: TMUrls.getTaskByStatusURL(selectedFilter),
      );

      if (response.isSuccess) {
        for (Map<String, dynamic> jsonData in (response.responseData['data'])) {
          result.add(TaskModel.fromJson(jsonData));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.responseData['data']))),
          );
        }
      }
    }

    setState(() {
      tasks = result;
      inProgress = false;
    });
  }

  Color colorForStatus(String? status) {
    switch (status) {
      case 'New': return Colors.blue;
      case 'Progress': return Colors.purple;
      case 'Completed': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> refreshAll() async {
    await getAllTaskCount();
    await getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ['New', 'Progress', 'Completed', 'Cancelled'].length,
                itemBuilder: (context, index) {
                  final status = ['New', 'Progress', 'Completed', 'Cancelled'][index];
                  final task = taskCount.firstWhere(
                    (e) => e.sId == status,
                    orElse: () => TaskStatusCountModel(sId: status, sum: 0),
                  );
                  return TaskCountByStatus(title: task.sId.toString(), count: task.sum ?? 0);
                },
                separatorBuilder: (context, index) => SizedBox(width: 20),
              ),
            ),
          ),

          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = filter == selectedFilter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() { selectedFilter = filter; });
                    getTasks();
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 8),
            ),
          ),

          SizedBox(height: 8),

          Expanded(
            child: inProgress
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        taskModel: task,
                        CardColor: colorForStatus(task.status),
                        refreshParent: () async { await refreshAll(); },
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
