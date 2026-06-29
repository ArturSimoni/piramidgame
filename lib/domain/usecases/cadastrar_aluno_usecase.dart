import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';

class CadastrarAlunoUseCase {
  final AlunoRepository _repository;
  CadastrarAlunoUseCase(this._repository);

  Future<Result<bool>> call(Aluno novoAluno) async {
    if (novoAluno.nome.trim().isEmpty) {
      return const Failure('O nome do aluno é obrigatório.');
    }
    final result = await _repository.buscarTodos();
    if (result is Success) {
      final lista = List<Aluno>.from((result as Success<List<Aluno>>).data);
      lista.add(novoAluno);
      return await _repository.salvar(lista);
    }
    return const Failure('Erro ao processar o cadastro.');
  }
}
