import 'package:flutter/material.dart';
import '../../models/task.dart';

class TasksSection extends StatelessWidget {
  final List<Task> tasks;
  final TextEditingController taskController;
  final Function(String) addTask;
  final Function(int) toggleTask;

  const TasksSection({
    Key? key,
    required this.tasks,
    required this.taskController,
    required this.addTask,
    required this.toggleTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Study Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addTask(taskController.text),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    tasks[index].text,
                    style: TextStyle(
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  value: tasks[index].isCompleted,
                  onChanged: (_) => toggleTask(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
