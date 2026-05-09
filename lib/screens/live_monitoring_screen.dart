import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../features/glucose/glucose_controller.dart';
import '../theme.dart';

class LiveMonitoringScreen extends StatelessWidget {
  const LiveMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlucoseController(),
      child: const _LiveMonitoringScreenContent(),
    );
  }
}

class _LiveMonitoringScreenContent extends StatefulWidget {
  const _LiveMonitoringScreenContent();

  @override
  State<_LiveMonitoringScreenContent> createState() => _LiveMonitoringScreenContentState();
}

class _LiveMonitoringScreenContentState extends State<_LiveMonitoringScreenContent> {
  bool _hasShownTimeout = false;
  bool _hasShownNoDevice = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GlucoseController>();
      controller.addListener(_onControllerUpdate);
    });
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final controller = context.read<GlucoseController>();
    if (controller.phase == "NoDevice" && !_hasShownNoDevice) {
      _hasShownNoDevice = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surfaceContainerHigh,
          title: const Text('Sensor Not Connected', style: TextStyle(color: AppTheme.error)),
          content: const Text('Please connect the ESP sensor via OTG before starting the recording.', style: TextStyle(color: AppTheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Go back
              },
              child: const Text('Go Back', style: TextStyle(color: AppTheme.primary)),
            ),
          ],
        ),
      );
    } else if (controller.phase == "Timeout" && !_hasShownTimeout) {
      _hasShownTimeout = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surfaceContainerHigh,
          title: const Text('Timeout', style: TextStyle(color: AppTheme.error)),
          content: const Text('No sensor data was received within 60 seconds.', style: TextStyle(color: AppTheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Go back
              },
              child: const Text('Go Back', style: TextStyle(color: AppTheme.primary)),
            ),
          ],
        ),
      );
    } else if (controller.phase == "Complete" && !_hasNavigated) {
      _hasNavigated = true;
      context.pushReplacement('/final_result', extra: controller.currentGlucose);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GlucoseController>();

    if (controller.phase == "Calibrating") {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.primary),
              const SizedBox(height: 24),
              Text(
                'Calibrating...',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
              const Text('Processing sensor data, please wait.', style: TextStyle(color: AppTheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Live Monitoring'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status & Quality
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      controller.status,
                      style: TextStyle(
                        color: controller.isConnected ? AppTheme.primary : AppTheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (controller.isConnected)
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.secondsLeft}s',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.signal_cellular_alt, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 4),
                        Text('${(controller.signalQuality * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Glucose Display
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.secondary, width: 4),
                    boxShadow: [
                      BoxShadow(color: AppTheme.secondary.withAlpha(51), blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        controller.currentGlucose != null
                            ? controller.currentGlucose!.toStringAsFixed(1)
                            : '--',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('mg/dL', style: TextStyle(color: AppTheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Real-time Graph
              const Text('PPG Waveform (IR & RED)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: controller.latestIrData.isEmpty
                      ? const Center(child: Text('Waiting for data...'))
                      : (() {
                          double minY = 0;
                          double maxY = 100;
                          if (controller.latestIrData.isNotEmpty && controller.latestRedData.isNotEmpty) {
                            double minIr = controller.latestIrData.reduce((a, b) => a < b ? a : b);
                            double maxIr = controller.latestIrData.reduce((a, b) => a > b ? a : b);
                            double minRed = controller.latestRedData.reduce((a, b) => a < b ? a : b);
                            double maxRed = controller.latestRedData.reduce((a, b) => a > b ? a : b);
                            double overallMin = minIr < minRed ? minIr : minRed;
                            double overallMax = maxIr > maxRed ? maxIr : maxRed;
                            double padding = (overallMax - overallMin) * 0.1;
                            if (padding == 0) padding = 100;
                            minY = overallMin - padding;
                            maxY = overallMax + padding;
                          }
                          return LineChart(
                            LineChartData(
                              minY: minY,
                              maxY: maxY,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.latestIrData
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                                LineChartBarData(
                                  spots: controller.latestRedData
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.red,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          );
                        })(),
                ),
              ),
              
              const SizedBox(height: 24),
              if (controller.phase == "Collecting")
                Center(
                  child: Text(
                    'Collecting Data... ${controller.secondsLeft} seconds left',
                    style: const TextStyle(color: AppTheme.primary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
