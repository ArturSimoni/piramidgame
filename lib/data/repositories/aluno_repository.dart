import '../../core/patterns/result.dart';
import '../../domain/models/aluno_model.dart';
import '../services/aluno_service.dart';

class AlunoRepository {
  final AlunoService _service;

  AlunoRepository(this._service);

  Future<Result<List<Aluno>>> buscarTodos() async {
    try {
      final jsonList = await _service.carregarAlunos();
      final alunos = jsonList.map((e) => Aluno.fromJson(e)).toList();
      return Success(alunos);
    } catch (e) {
      return Failure('Erro ao buscar alunos: ${e.toString()}');
    }
  }

  Future<Result<Aluno?>> buscarPorId(String id) async {
    try {
      final jsonList = await _service.carregarAlunos();
      final alunos = jsonList.map((e) => Aluno.fromJson(e)).toList();
      final encontrado = alunos.where((a) => a.id == id).firstOrNull;
      return Success(encontrado);
    } catch (e) {
      return Failure('Erro ao buscar aluno: ${e.toString()}');
    }
  }

  Future<Result<bool>> salvar(List<Aluno> alunos) async {
    try {
      final jsonList = alunos.map((e) => e.toJson()).toList();
      await _service.salvarAlunos(jsonList);
      return const Success(true);
    } catch (e) {
      return Failure('Erro ao salvar alunos: ${e.toString()}');
    }
  }
}
