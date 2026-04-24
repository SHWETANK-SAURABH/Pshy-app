import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/psychologist.dart';

// Mock Provider List for now
final mockPsychologists = [
  Psychologist(
    id: '1',
    firstName: 'Dr. Sarah',
    lastName: 'Jenkins',
    gender: 'Female',
    yearsOfExperience: 10,
    areasOfExpertise: ['Anxiety', 'Depression'],
    languages: ['English', 'Spanish'],
    consultationFee: 150.0,
    isActive: true,
  ),
  Psychologist(
    id: '2',
    firstName: 'Dr. Marcus',
    lastName: 'Chen',
    gender: 'Male',
    yearsOfExperience: 7,
    areasOfExpertise: ['Relationship Issues', 'Stress'],
    languages: ['English', 'Mandarin'],
    consultationFee: 130.0,
    isActive: true,
  ),
];

class PsychologistDirectoryScreen extends StatelessWidget {
  const PsychologistDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app we'd watch a Riverpod provider here
    final activePsychologists = mockPsychologists.where((p) => p.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Psychologists'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activePsychologists.length,
        itemBuilder: (context, index) {
          final p = activePsychologists[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(p.firstName[0] + p.lastName[0], style: const TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${p.firstName} ${p.lastName}', style: Theme.of(context).textTheme.titleLarge),
                            Text('${p.yearsOfExperience} years experience', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Text('\$${p.consultationFee}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.areasOfExpertise.map((e) => Chip(
                      label: Text(e, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/book/${p.id}'),
                      child: const Text('Book Session'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
