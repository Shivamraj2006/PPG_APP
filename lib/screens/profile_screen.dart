import 'package:flutter/material.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainer.withOpacity(0.8),
        title: const Text(
          'GLUCOWAVE',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Profile Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.2),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppTheme.surfaceVariant,
                      child: Icon(Icons.person, size: 64, color: AppTheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Alex Rivera',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primary,
                      shadows: [
                        Shadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 10)
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PREMIUM MEMBER • ID: 88241',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Info Grid
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, Icons.call, 'Phone', '+1 (555) 012-3456')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, Icons.monitor_weight, 'Weight', '72 kg')),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard(context, Icons.straighten, 'Height', '178 cm')),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(context, Icons.bloodtype, 'Blood Type', 'O+', isBloodType: true),
            const SizedBox(height: 32),
            // Actions
            Text('MEDICAL MANAGEMENT', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            _buildActionCard(context, Icons.history_edu, 'Medical History', AppTheme.primary),
            const SizedBox(height: 8),
            _buildActionCard(context, Icons.contact_emergency, 'Emergency Contacts', AppTheme.error),
            const SizedBox(height: 8),
            _buildActionCard(context, Icons.settings_applications, 'App Settings', AppTheme.secondary),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppTheme.error),
              label: const Text('Sign Out of GlucoWave', style: TextStyle(color: AppTheme.error)),
            ),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value, {bool isBloodType = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: isBloodType ? AppTheme.error : AppTheme.primary, size: 24),
              if (label == 'Weight')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('-2kg', style: TextStyle(color: AppTheme.secondary, fontSize: 10, fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 12),
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.onSurfaceVariant, fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            style: isBloodType
                ? Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppTheme.error)
                : Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
          const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
