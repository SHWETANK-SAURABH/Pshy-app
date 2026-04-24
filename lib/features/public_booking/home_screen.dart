import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primarySoft = colorScheme.primary.withAlpha(26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GRADient Booking', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => context.go('/admin'),
            tooltip: 'Admin Portal',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              color: primarySoft,
              child: Column(
                children: [
                  Text(
                    'Professional Psychology Sessions',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Book a secure, private session with top certified psychologists without creating an account.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go('/directory'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text('Book an Appointment', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            
            // About Us Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Us', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(
                    'GRADient is a premium platform connecting you with specialized psychologists. We value your privacy and aim to provide seamless booking and consultation experiences. All data is securely handled without the need for client portals.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // Issue Types Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Common Issues We Address', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildIssueChip(context, 'Anxiety'),
                      _buildIssueChip(context, 'Depression'),
                      _buildIssueChip(context, 'Relationship Issues'),
                      _buildIssueChip(context, 'Stress Management'),
                      _buildIssueChip(context, 'Career Guidance'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label),
      backgroundColor: colorScheme.secondary.withAlpha(51),
      side: BorderSide.none,
    );
  }
}
