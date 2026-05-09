import 'package:flutter/material.dart';
import '../theme.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainer.withOpacity(0.8),
        title: const Text('Trends & Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Average Glucose', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('104', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.primary)),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                      child: Text('mg/dL', style: TextStyle(color: AppTheme.onSurfaceVariant)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Mock Chart area
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppTheme.primary.withOpacity(0.0),
                        AppTheme.primary.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Grid lines
                      for (int i = 0; i < 4; i++)
                        Positioned(
                          bottom: i * 50.0,
                          left: 0,
                          right: 0,
                          child: Container(height: 1, color: AppTheme.surfaceVariant),
                        ),
                      // Fake trend line (just a simple curve path or icon)
                      const Center(
                        child: Icon(Icons.trending_up, size: 80, color: AppTheme.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Key Insights', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          _buildInsightCard(context, Icons.check_circle, 'In Target Range', '85% of your readings are normal.', AppTheme.secondary),
          const SizedBox(height: 16),
          _buildInsightCard(context, Icons.restaurant, 'Post-meal Spikes', 'Slight elevation detected after lunch.', AppTheme.error),
          const SizedBox(height: 80), // Padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
