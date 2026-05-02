import '../repositories/psychologist_repository.dart';

class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<void> execute({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
