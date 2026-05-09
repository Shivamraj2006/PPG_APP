import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ColorFilter.mode(Colors.black.withOpacity(0.01), BlendMode.dstATop),
            child: AppBar(
              backgroundColor: AppTheme.surfaceContainer.withOpacity(0.8),
              elevation: 0,
              title: Row(
                children: [
                  const Icon(Icons.waves, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'GLUCOWAVE',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppTheme.primary,
                      shadows: [
                        Shadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 8),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        border: Border.all(color: const Color(0xFF45475A)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10)
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SENSOR CONNECTED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Color(0xFFA6ADC8),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.5, -0.8),
            radius: 1.5,
            colors: [
              AppTheme.primary.withOpacity(0.05),
              AppTheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // Dashboard Summary Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(context, 'Last Reading', '112', 'mg/dL', AppTheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(context, 'Daily Range', '94%', 'Target', AppTheme.secondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Primary Action Area: Glowing Button
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 256,
                            height: 256,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppTheme.primary.withOpacity(0.15), blurRadius: 60, spreadRadius: 10),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => context.push('/live_monitoring'),
                            borderRadius: BorderRadius.circular(150),
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.surfaceContainer,
                                border: Border.all(color: AppTheme.surfaceVariant, width: 4),
                                boxShadow: [
                                  BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 30, spreadRadius: 10),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 210,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1),
                                    ),
                                  ),
                                  Container(
                                    width: 240,
                                    height: 240,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF45475A).withOpacity(0.5), style: BorderStyle.solid), // Dashed normally, using solid with low opacity for ease
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.sensors, color: AppTheme.primary, size: 50),
                                      const SizedBox(height: 16),
                                      Text(
                                        'START MEASUREMENT',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Center(
                      child: Text(
                        'Ensure your device is connected and place your finger on the sensor to begin analysis.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFA6ADC8), fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Visual Guidance Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.surfaceVariant.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Phone Illustration
                              Container(
                                width: 60,
                                height: 100,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF45475A)),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.waves, size: 16, color: Color(0xFF45475A)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Cable & Hub
                              Container(
                                width: 32,
                                height: 4,
                                color: const Color(0xFF45475A),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 48,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.1),
                                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.bolt, color: AppTheme.primary, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'CONNECTION GUIDE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Color(0xFF6C7086),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'USB-C Sensor Hub Detected',
                            style: TextStyle(color: Color(0xFFA6ADC8), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Padding for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, String unit, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C7086),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: valueColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C7086),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
