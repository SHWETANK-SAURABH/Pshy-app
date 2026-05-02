import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/psychologist_user.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../../psychologist_portal_providers.dart';
import 'auth_controller.dart';

class ProfileState {
  final bool isUpdating;
  final PsychologistUser? user;
  final String? message;
  final String? error;

  ProfileState({
    required this.isUpdating,
    this.user,
    this.message,
    this.error,
  });

  factory ProfileState.initial(PsychologistUser? user) => ProfileState(
        isUpdating: false,
        user: user,
      );

  ProfileState copyWith({
    bool? isUpdating,
    PsychologistUser? user,
    String? message,
    String? error,
  }) {
    return ProfileState(
      isUpdating: isUpdating ?? this.isUpdating,
      user: user ?? this.user,
      message: message,
      error: error,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(Ref ref)
      : _ref = ref,
        _updateProfileUseCase = ref.read(updateProfileUseCaseProvider),
        super(ProfileState.initial(ref.read(authControllerProvider).user));

  final Ref _ref;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> refreshProfile() async {
    final loggedUser = _ref.read(authControllerProvider).user;
    state = state.copyWith(user: loggedUser);
  }

  Future<void> updateProfile({
    required String name,
    required List<String> expertise,
    required List<String> languages,
  }) async {
    if (state.user == null) {
      state = state.copyWith(error: 'No active profile is available.');
      return;
    }
    state = state.copyWith(isUpdating: true, message: null, error: null);
    try {
      final updatedUser = await _updateProfileUseCase.execute(
        user: state.user!.copyWith(
          name: name,
          expertise: expertise,
          languages: languages,
        ),
      );
      _ref.read(authControllerProvider.notifier).state = AuthState(
        status: AuthStatus.authenticated,
        user: updatedUser,
      );
      state = state.copyWith(isUpdating: false, user: updatedUser, message: 'Profile updated successfully.');
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());
    }
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>(
  (ref) => ProfileController(ref),
);
