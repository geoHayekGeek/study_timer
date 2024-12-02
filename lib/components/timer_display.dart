import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int minutes;
  final int seconds;
  final bool isRunning;
  final VoidCallback toggleTimer;
  final VoidCallback resetTimer;

  const TimerDisplay({
    Key? key,
    required this.minutes,
    required this.seconds,
    required this.isRunning,
    required this.toggleTimer,
    required this.resetTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: toggleTimer,
                  child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: resetTimer,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
