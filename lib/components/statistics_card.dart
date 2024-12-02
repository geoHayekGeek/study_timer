import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final int sessionsCompleted;

  const StatisticsCard({Key? key, required this.sessionsCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sessions Completed Today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              '$sessionsCompleted',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
