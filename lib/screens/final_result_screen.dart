import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class FinalResultScreen extends StatelessWidget {
  const FinalResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Result Analysis'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceContainerHigh,
                  border: Border.all(color: AppTheme.secondary, width: 4),
                  boxShadow: [
                    BoxShadow(color: AppTheme.secondary.withOpacity(0.3), blurRadius: 30)
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '98',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.secondary,
                        fontSize: 72,
                      ),
                    ),
                    const Text('mg/dL', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text('Normal Blood Glucose', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.secondary)),
              const SizedBox(height: 16),
              const Text(
                'Your reading is within the normal range. Keep up the good work and maintain a healthy diet!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 16, height: 1.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pushReplacement('/live_monitoring'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Retake Reading', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
