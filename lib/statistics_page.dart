import 'package:flutter/material.dart';
import 'services/flutter-api-service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? statistics;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _apiService.getStatistics();
      setState(() {
        statistics = stats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
      print('Error loading statistics: $e');
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),  // Reduced from 16
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Added to minimize height
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),  // Reduced from 32
            const SizedBox(height: 4),  // Reduced from 8
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,  // Reduced from 16
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),  // Reduced from 8
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,  // Reduced from 24
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Statistics'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,  // Reduced from 16
                crossAxisSpacing: 8,  // Reduced from 16
                childAspectRatio: 1.2,  // Added to make cards shorter
                padding: EdgeInsets.zero,  // Added to remove grid padding
                children: [
                  _buildStatCard(
                    'Total Sessions',
                    '${statistics?['total_sessions'] ?? 0}',
                    Icons.timer,
                  ),
                  _buildStatCard(
                    'Total Study Time',
                    _formatDuration(statistics?['total_study_minutes'] ?? 0),
                    Icons.access_time,
                  ),
                  _buildStatCard(
                    'Tasks Completed Today',
                    '${statistics?['completed_today'] ?? 0}',
                    Icons.today,
                  ),
                  _buildStatCard(
                    'Total Tasks Completed',
                    '${statistics?['completed_tasks'] ?? 0}',
                    Icons.task_alt,
                  ),
                  _buildStatCard(
                    'Ongoing Tasks',
                    '${statistics?['ongoing_tasks'] ?? 0}',
                    Icons.pending_actions,
                  ),
                  _buildStatCard(
                    'Total Tasks',
                    '${statistics?['total_tasks'] ?? 0}',
                    Icons.format_list_bulleted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}