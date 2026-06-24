// lib/domain/usecases/calcular_ranking_usecase.dart

import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';

class CalcularRankingUseCase {
  final AlunoRepository _repository;
  CalcularRankingUseCase(this._repository);

  Future<Result<List<Aluno>>> call() async {
    final result = await _repository.buscarTodos();
    if (result is Success) {
      final lista = List<Aluno>.from((result as Success<List<Aluno>>).data);
      lista.sort((a, b) => b.nivelLenda.compareTo(a.nivelLenda));
      return Success(lista);
    }
    return const Failure('Erro ao gerar ranking.');
  }
}
