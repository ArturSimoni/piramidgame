// lib/domain/usecases/alterar_aluno_usecase.dart

import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';

class AlterarAlunoUseCase {
  final AlunoRepository _repository;
  AlterarAlunoUseCase(this._repository);

  Future<Result<bool>> call(Aluno alunoAtualizado) async {
    if (alunoAtualizado.nome.trim().isEmpty) {
      return const Failure('O nome do aluno é obrigatório.');
    }
    final result = await _repository.buscarTodos();
    if (result is Success) {
      final lista = List<Aluno>.from((result as Success<List<Aluno>>).data);
      final idx = lista.indexWhere((a) => a.id == alunoAtualizado.id);
      if (idx == -1) return const Failure('Aluno não encontrado.');
      lista[idx] = alunoAtualizado;
      return await _repository.salvar(lista);
    }
    return const Failure('Erro ao processar a alteração.');
  }
}
