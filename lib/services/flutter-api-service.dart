import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  final String baseUrl = 'https://c82a-185-187-94-92.ngrok-free.app/backend';

  Future<List<Task>> getTodayTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks.php'));
    if (response.statusCode == 200) {
      List<dynamic> tasksJson = jsonDecode(response.body);
      return tasksJson.map((json) => Task(
        id: json['id'],
        text: json['text'],
        isCompleted: json['is_completed'] == 1,
        createdAt: DateTime.parse(json['created_at']),
      )).toList();
    }
    throw Exception('Failed to load tasks');
  }

  Future<Task> createTask(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks.php'),
      body: jsonEncode({'text': text}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Task(
        id: json['id'],
        text: text,
        createdAt: DateTime.now(),
      );
    }
    throw Exception('Failed to create task');
  }

  Future<void> updateTaskStatus(int id, bool isCompleted) async {
    await http.put(
      Uri.parse('$baseUrl/tasks.php'),
      body: jsonEncode({
        'id': id,
        'is_completed': isCompleted ? 1 : 0,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<int> getTodaySessionCount() async {
    final response = await http.get(Uri.parse('$baseUrl/sessions.php'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['count'];
    }
    throw Exception('Failed to load session count');
  }

  Future<void> incrementSessionCount() async {
    await http.post(Uri.parse('$baseUrl/sessions.php'));
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final response = await http.get(Uri.parse('$baseUrl/statistics.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load statistics');
  }
}
