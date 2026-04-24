import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/'),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Total Sessions', '1,248', Icons.calendar_month)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Active Psychologists', '12', Icons.people)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Revenue', '\$145K', Icons.attach_money)),
              ],
            ),
            const SizedBox(height: 40),
            Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildActionCard(
                  context,
                  'Manage Psychologists',
                  Icons.manage_accounts,
                  () => context.push('/admin/psychologists'),
                ),
                _buildActionCard(
                  context,
                  'View All Bookings',
                  Icons.list_alt,
                  () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bookings view coming soon'))),
                ),
                _buildActionCard(
                  context,
                  'Edit Website Content',
                  Icons.edit_document,
                  () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CMS coming soon'))),
                ),
                _buildActionCard(
                  context,
                  'Generate Reports',
                  Icons.analytics,
                  () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reports coming soon'))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
