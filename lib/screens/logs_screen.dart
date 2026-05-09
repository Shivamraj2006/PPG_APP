import 'package:flutter/material.dart';
import '../theme.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainer.withOpacity(0.8),
        title: const Text('History Logs'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final isNormal = index % 3 != 0;
          final value = isNormal ? 98 + index : 140 + index;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceVariant),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isNormal ? AppTheme.secondary.withOpacity(0.2) : AppTheme.error.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.water_drop, color: isNormal ? AppTheme.secondary : AppTheme.error),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isNormal ? 'Normal' : 'Elevated', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Today, 10:${30 - index} AM', style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                Text('$value', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: isNormal ? AppTheme.secondary : AppTheme.error)),
                const SizedBox(width: 4),
                const Text('mg/dL', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
