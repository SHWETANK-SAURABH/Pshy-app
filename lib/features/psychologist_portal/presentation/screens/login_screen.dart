import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

class PsychologistLoginScreen extends ConsumerStatefulWidget {
  const PsychologistLoginScreen({super.key});

  @override
  ConsumerState<PsychologistLoginScreen> createState() => _PsychologistLoginScreenState();
}

class _PsychologistLoginScreenState extends ConsumerState<PsychologistLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).forgotPassword(email: emailController.text.trim());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('If the email exists, recovery instructions were sent.')));
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  bool _hasShownError = false;
  bool _hasRedirected = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.status == AuthStatus.authenticated && !_hasRedirected) {
      _hasRedirected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/psychologist/dashboard');
        }
      });
    }

    if (authState.status == AuthStatus.failure && authState.message != null && !_hasShownError) {
      _hasShownError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message!)));
        }
      });
    }

    final isLoading = authState.status == AuthStatus.loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Psychologist Portal')),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 12),
              Text('Sign in to manage sessions, availability, and your profile.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 36),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  ref.read(authControllerProvider.notifier).login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                }
                              },
                        child: isLoading ? const CircularProgressIndicator() : const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    if (authState.status == AuthStatus.failure && authState.message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(authState.message!, style: const TextStyle(color: Colors.redAccent)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
