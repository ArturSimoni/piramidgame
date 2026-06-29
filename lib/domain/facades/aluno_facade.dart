import '../../core/patterns/result.dart';
import '../../data/repositories/aluno_repository.dart';
import '../models/aluno_model.dart';
import '../usecases/cadastrar_aluno_usecase.dart';
import '../usecases/alterar_aluno_usecase.dart';
import '../usecases/remover_aluno_usecase.dart';
import '../usecases/buscar_alunos_usecase.dart';
import '../usecases/buscar_aluno_por_id_usecase.dart';
import '../usecases/calcular_ranking_usecase.dart';

class AlunoFacade {
  final CadastrarAlunoUseCase _cadastrar;
  final AlterarAlunoUseCase _alterar;
  final RemoverAlunoUseCase _remover;
  final BuscarAlunosUseCase _buscarTodos;
  final BuscarAlunoPorIdUseCase _buscarPorId;
  final CalcularRankingUseCase _calcularRanking;

  AlunoFacade({
    required CadastrarAlunoUseCase cadastrar,
    required AlterarAlunoUseCase alterar,
    required RemoverAlunoUseCase remover,
    required BuscarAlunosUseCase buscarTodos,
    required BuscarAlunoPorIdUseCase buscarPorId,
    required CalcularRankingUseCase calcularRanking,
  })  : _cadastrar = cadastrar,
        _alterar = alterar,
        _remover = remover,
        _buscarTodos = buscarTodos,
        _buscarPorId = buscarPorId,
        _calcularRanking = calcularRanking;

  factory AlunoFacade.create(AlunoRepository repository) {
    return AlunoFacade(
      cadastrar: CadastrarAlunoUseCase(repository),
      alterar: AlterarAlunoUseCase(repository),
      remover: RemoverAlunoUseCase(repository),
      buscarTodos: BuscarAlunosUseCase(repository),
      buscarPorId: BuscarAlunoPorIdUseCase(repository),
      calcularRanking: CalcularRankingUseCase(repository),
    );
  }

  Future<Result<bool>> cadastrarAluno(Aluno aluno) => _cadastrar(aluno);
  Future<Result<bool>> alterarAluno(Aluno aluno) => _alterar(aluno);
  Future<Result<bool>> removerAluno(String id) => _remover(id);
  Future<Result<List<Aluno>>> buscarTodosAlunos() => _buscarTodos();
  Future<Result<Aluno?>> buscarAlunoPorId(String id) => _buscarPorId(id);
  Future<Result<List<Aluno>>> calcularRanking() => _calcularRanking();
}
