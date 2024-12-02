import 'package:flutter/material.dart';
import 'dart:async';
import 'models/task.dart';
import 'components/timer_display.dart';
import 'components/statistics_card.dart';
import 'components/tasks_section.dart';

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

  @override
  void dispose() {
    timer?.cancel();
    _taskController.dispose();
    super.dispose();
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
            sessionsCompleted++;
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

  void addTask(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        tasks.add(Task(text: text));
        _taskController.clear();
      });
    }
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
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
