// lib/domain/usecases/remover_aluno_usecase.dart

import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';

class RemoverAlunoUseCase {
  final AlunoRepository _repository;
  RemoverAlunoUseCase(this._repository);

  Future<Result<bool>> call(String id) async {
    final result = await _repository.buscarTodos();
    if (result is Success) {
      final lista = (result as Success).data..removeWhere((a) => a.id == id);
      return await _repository.salvar(lista);
    }
    return const Failure('Erro ao remover aluno.');
  }
}
