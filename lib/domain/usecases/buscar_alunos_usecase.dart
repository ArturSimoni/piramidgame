import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';

class BuscarAlunosUseCase {
  final AlunoRepository _repository;
  BuscarAlunosUseCase(this._repository);

  Future<Result<List<Aluno>>> call() => _repository.buscarTodos();
}
