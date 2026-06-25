// lib/presentation/student/aluno_viewmodel.dart

import 'package:signals/signals.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/facades/aluno_facade.dart';
import '../../domain/models/aluno_model.dart';

class AlunoViewModel {
  final AlunoFacade _facade;

  AlunoViewModel(this._facade) {
    carregarAlunosCommand = Command0(_carregarAlunos);
    calcularRankingCommand = Command0(_calcularRanking);
    cadastrarCommand = Command1(_cadastrar);
    alterarCommand = Command1(_alterar);
    removerCommand = Command1(_remover);
    buscarPorIdCommand = Command1(_buscarPorId);
  }

  final alunos = signal<List<Aluno>>([]);
  final ranking = signal<List<Aluno>>([]);
  final alunoSelecionado = signal<Aluno?>(null);
  final errorMessage = signal<String?>(null);

  late final Command0<List<Aluno>> carregarAlunosCommand;
  late final Command0<List<Aluno>> calcularRankingCommand;
  late final Command1<bool, Aluno> cadastrarCommand;
  late final Command1<bool, Aluno> alterarCommand;
  late final Command1<bool, String> removerCommand;
  late final Command1<Aluno?, String> buscarPorIdCommand;

  Future<Result<List<Aluno>>> _carregarAlunos() async {
    final result = await _facade.buscarTodosAlunos();
    if (result is Success) {
      alunos.value = (result as Success<List<Aluno>>).data;
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }

  Future<Result<List<Aluno>>> _calcularRanking() async {
    final result = await _facade.calcularRanking();
    if (result is Success) {
      ranking.value = (result as Success<List<Aluno>>).data;
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }

  Future<Result<bool>> _cadastrar(Aluno aluno) async {
    final result = await _facade.cadastrarAluno(aluno);
    if (result is Success) {
      await _carregarAlunos();
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }

  Future<Result<bool>> _alterar(Aluno aluno) async {
    final result = await _facade.alterarAluno(aluno);
    if (result is Success) {
      await _carregarAlunos();
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }

  Future<Result<bool>> _remover(String id) async {
    final result = await _facade.removerAluno(id);
    if (result is Success) {
      await _carregarAlunos();
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }

  Future<Result<Aluno?>> _buscarPorId(String id) async {
    final result = await _facade.buscarAlunoPorId(id);
    if (result is Success) {
      alunoSelecionado.value = (result as Success<Aluno?>).data;
      errorMessage.value = null;
    } else {
      errorMessage.value = (result as Failure).message;
    }
    return result;
  }
}
