import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/mood_provider.dart';
import '../providers/journal_provider.dart';
import '../services/analytics_service.dart';
import '../models/mood_entry.dart';
import 'package:intl/intl.dart';

/// Analytics Page
/// 
/// Shows insights and patterns from mood and journal data
/// Now with real charts and statistics!
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  String _formatMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'great':
        return 'Great';
      case 'good':
        return 'Good';
      case 'okay':
        return 'Okay';
      case 'down':
        return 'Down';
      case 'struggling':
        return 'Struggling';
      default:
        return mood;
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsService = AnalyticsService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights & Analytics'),
      ),
      body: SafeArea(
        child: Consumer2<MoodProvider, JournalProvider>(
          builder: (context, moodProvider, journalProvider, child) {
            final moodEntries = moodProvider.moodEntries;
            final journalEntries = journalProvider.journalEntries;

            // Calculate statistics
            final avgMood = moodEntries.isEmpty
                ? 0.0
                : analyticsService.calculateAverageMood(moodEntries);
            final mostCommonMood = analyticsService.getMostCommonMood(moodEntries);
            final weeklySummary = analyticsService.getWeeklySummary(
              moodEntries,
              journalEntries,
            );
            final moodTrend = analyticsService.getMoodTrendData(moodEntries, 7);
            final moodDistribution = analyticsService.getMoodDistribution(moodEntries);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Your Wellness Insights',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover patterns in your mental wellness journey',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.calendar_today,
                          label: 'Days Tracked',
                          value: moodEntries.length.toString(),
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.book,
                          label: 'Journal Entries',
                          value: journalEntries.length.toString(),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.mood,
                          label: 'Average Mood',
                          value: avgMood > 0
                              ? avgMood.toStringAsFixed(1)
                              : '—',
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.insights,
                          label: 'Most Common',
                          value: _formatMood(mostCommonMood),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Mood trend chart
                  if (moodEntries.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '7-Day Mood Trend',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: _buildMoodTrendChart(moodTrend),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.bar_chart, size: 48, color: Colors.grey[600]),
                              const SizedBox(height: 12),
                              Text(
                                'No mood data yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Mood distribution chart
                  if (moodEntries.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.pie_chart,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Mood Distribution',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: _buildMoodDistributionChart(moodDistribution),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Weekly summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_view_week,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'This Week\'s Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSummaryItem(
                            'Mood entries',
                            weeklySummary['moodCount'].toString(),
                            Icons.mood,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryItem(
                            'Journal entries',
                            weeklySummary['journalCount'].toString(),
                            Icons.book,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryItem(
                            'Average mood',
                            weeklySummary['averageMood'] > 0
                                ? weeklySummary['averageMood'].toStringAsFixed(1)
                                : '—',
                            Icons.star,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryItem(
                            'Most common mood',
                            _formatMood(weeklySummary['mostCommonMood']),
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // AI Insights section
                  Card(
                    color: Colors.purple.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.psychology,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI-Powered Insights',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'In the full version, AI will analyze your journal entries and mood patterns to provide personalized insights and recommendations.',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTrendChart(List<Map<String, dynamic>> trendData) {
    if (trendData.isEmpty || trendData.every((d) => d['averageMood'] == 0.0)) {
      return Center(
        child: Text(
          'Not enough data yet',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < trendData.length) {
                  final date = trendData[value.toInt()]['date'] as DateTime;
                  return Text(
                    DateFormat('MMM d').format(date),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: trendData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value['averageMood'] as double,
              );
            }).toList(),
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.purple.withOpacity(0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: 5,
      ),
    );
  }

  Widget _buildMoodDistributionChart(Map<String, int> distribution) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    if (total == 0) {
      return Center(
        child: Text(
          'No data yet',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    final colors = {
      'great': Colors.green,
      'good': Colors.blue,
      'okay': Colors.orange,
      'down': Colors.purple,
      'struggling': Colors.red,
    };

    return PieChart(
      PieChartData(
        sections: distribution.entries.map((entry) {
          final percentage = (entry.value / total * 100);
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${percentage.toStringAsFixed(0)}%',
            color: colors[entry.key] ?? Colors.grey,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
