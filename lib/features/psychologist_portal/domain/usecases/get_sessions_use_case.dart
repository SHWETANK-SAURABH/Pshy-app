import '../entities/session_page.dart';
import '../repositories/psychologist_repository.dart';

class GetSessionsUseCase {
  GetSessionsUseCase(this._repository);

  final PsychologistRepository _repository;

  Future<SessionPage> execute({required String status, required int page, required int pageSize}) {
    return _repository.getSessions(status: status, page: page, pageSize: pageSize);
  }
}
