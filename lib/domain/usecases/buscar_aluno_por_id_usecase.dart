import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';

class BuscarAlunoPorIdUseCase {
  final AlunoRepository _repository;
  BuscarAlunoPorIdUseCase(this._repository);

  Future<Result<Aluno?>> call(String id) => _repository.buscarPorId(id);
}
