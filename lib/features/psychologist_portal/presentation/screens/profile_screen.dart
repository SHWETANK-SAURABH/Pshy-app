import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _expertiseController;
  late final TextEditingController _languagesController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _expertiseController = TextEditingController(text: currentUser?.expertise.join(', ') ?? '');
    _languagesController = TextEditingController(text: currentUser?.languages.join(', ') ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _expertiseController.dispose();
    _languagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    final user = profileState.user ?? ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage account', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expertiseController,
              decoration: const InputDecoration(labelText: 'Expertise (comma separated)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _languagesController,
              decoration: const InputDecoration(labelText: 'Languages (comma separated)'),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: profileState.isUpdating
                    ? null
                    : () {
                        controller.updateProfile(
                          name: _nameController.text.trim(),
                          expertise: _expertiseController.text
                              .split(',')
                              .map((value) => value.trim())
                              .where((value) => value.isNotEmpty)
                              .toList(),
                          languages: _languagesController.text
                              .split(',')
                              .map((value) => value.trim())
                              .where((value) => value.isNotEmpty)
                              .toList(),
                        );
                      },
                child: profileState.isUpdating ? const CircularProgressIndicator() : const Text('Save profile'),
              ),
            ),
            const SizedBox(height: 16),
            if (profileState.message != null)
              Text(profileState.message!, style: const TextStyle(color: Colors.green)),
            if (profileState.error != null)
              Text(profileState.error!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 24),
            if (user != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logged in as ${user.email}', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Role: ${user.role}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
