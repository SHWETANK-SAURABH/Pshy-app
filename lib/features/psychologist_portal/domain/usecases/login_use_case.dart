import '../entities/psychologist_user.dart';
import '../repositories/psychologist_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<PsychologistUser> execute({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
