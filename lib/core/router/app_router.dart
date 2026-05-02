import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/public_booking/home_screen.dart';
import '../../features/public_booking/psychologist_directory_screen.dart';
import '../../features/public_booking/booking_flow_screen.dart';
import '../../features/admin_portal/admin_dashboard.dart';
import '../../features/admin_portal/psychologist_crud_screen.dart';
import '../../features/psychologist_portal/presentation/screens/login_screen.dart';
import '../../features/psychologist_portal/presentation/screens/dashboard_screen.dart';
import '../../features/psychologist_portal/presentation/screens/availability_screen.dart';
import '../../features/psychologist_portal/presentation/screens/sessions_screen.dart';
import '../../features/psychologist_portal/presentation/screens/profile_screen.dart';
import '../../features/psychologist_portal/presentation/psychologist_portal_shell.dart';
import '../../features/psychologist_portal/psychologist_portal_providers.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isLoading = false;

  void _login() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.go('/admin/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Portal')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Admin Secure Login (MFA Mock)'),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Username')),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 24),
              _isLoading 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Public UI'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(tokenProvider) != null;
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PublicHomeScreen(),
      ),
      GoRoute(
        path: '/directory',
        builder: (context, state) => const PsychologistDirectoryScreen(),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingFlowScreen(psychologistId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/psychologists',
        builder: (context, state) => const PsychologistCrudScreen(),
      ),
      GoRoute(
        path: '/psychologist/login',
        builder: (context, state) => const PsychologistLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => PsychologistPortalShell(
          location: state.uri.toString(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/psychologist/dashboard',
            builder: (context, state) => const PsychologistDashboardScreen(),
          ),
          GoRoute(
            path: '/psychologist/availability',
            builder: (context, state) => const AvailabilityManagementScreen(),
          ),
          GoRoute(
            path: '/psychologist/sessions',
            builder: (context, state) => const SessionsScreen(),
          ),
          GoRoute(
            path: '/psychologist/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final location = state.uri.toString();
      final isPsychologistRoute = location.startsWith('/psychologist');
      final isLoginRoute = location == '/psychologist/login';
      if (isPsychologistRoute && !isLoginRoute && !isLoggedIn) {
        return '/psychologist/login';
      }
      if (isLoginRoute && isLoggedIn) {
        return '/psychologist/dashboard';
      }
      return null;
    },
  );
});
