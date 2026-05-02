import '../entities/psychologist_user.dart';
import '../repositories/psychologist_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<PsychologistUser> execute({required PsychologistUser user}) {
    return _repository.updateProfile(user: user);
  }
}
