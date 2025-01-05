import 'package:flutter/material.dart';
import 'dart:async';
import 'models/task.dart';
import 'components/timer_display.dart';
import 'components/statistics_card.dart';
import 'components/tasks_section.dart';
import 'services/flutter-api-service.dart';

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  int minutes = 25;
  int seconds = 0;
  bool isRunning = false;
  bool isBreak = false;
  int sessionsCompleted = 0;
  Timer? timer;
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadSessionCount();
  }

  @override
  void dispose() {
    timer?.cancel();
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final loadedTasks = await _apiService.getTodayTasks();
      setState(() => tasks = loadedTasks);
    } catch (e) {
      // Handle error appropriately
      print('Error loading tasks: $e');
    }
  }

  Future<void> _loadSessionCount() async {
    try {
      final count = await _apiService.getTodaySessionCount();
      setState(() => sessionsCompleted = count);
    } catch (e) {
      // Handle error appropriately
      print('Error loading session count: $e');
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else if (minutes > 0) {
          minutes--;
          seconds = 59;
        } else {
          timer.cancel();
          if (!isBreak) {
            _incrementSessionCount();
          }
          isBreak = !isBreak;
          minutes = isBreak ? 5 : 25;
          seconds = 0;
          isRunning = false;
          _showCompletionDialog();
        }
      });
    });
  }

  Future<void> _incrementSessionCount() async {
    try {
      await _apiService.incrementSessionCount();
      await _loadSessionCount();
    } catch (e) {
      // Handle error appropriately
      print('Error incrementing session count: $e');
    }
  }

  void toggleTimer() {
    setState(() {
      isRunning = !isRunning;
      if (isRunning) {
        startTimer();
      } else {
        timer?.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
      isBreak = false;
      minutes = 25;
      seconds = 0;
    });
  }

  void addTask(String text) async {
    if (text.trim().isNotEmpty) {
      try {
        await _apiService.createTask(text);
        _loadTasks();
        _taskController.clear();
      } catch (e) {
        // Handle error appropriately
        print('Error adding task: $e');
      }
    }
  }

  void toggleTask(int index) async {
    try {
      final task = tasks[index];
      await _apiService.updateTaskStatus(task.id!, !task.isCompleted);
      _loadTasks();
    } catch (e) {
      // Handle error appropriately
      print('Error toggling task: $e');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBreak ? 'Break Time!' : 'Study Session Complete!'),
        content: Text(
          isBreak
              ? 'Take a 5-minute break.'
              : 'Great job! You\'ve completed a study session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isBreak ? '😌 Break Time' : '📚 Study Time'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistics',
            onPressed: () => Navigator.pushNamed(context, '/statistics'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TimerDisplay(
                minutes: minutes,
                seconds: seconds,
                isRunning: isRunning,
                toggleTimer: toggleTimer,
                resetTimer: resetTimer,
              ),
              const SizedBox(height: 20),
              StatisticsCard(sessionsCompleted: sessionsCompleted),
              const SizedBox(height: 20),
              TasksSection(
                tasks: tasks,
                taskController: _taskController,
                addTask: addTask,
                toggleTask: toggleTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}