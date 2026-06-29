import '../../core/patterns/result.dart';
import '../../data/services/theme_service.dart';
import '../usecases/alterar_tema_usecase.dart';

class ThemeFacade {
  final CarregarTemaUseCase _carregar;
  final AlterarTemaUseCase _alterar;

  ThemeFacade({
    required CarregarTemaUseCase carregar,
    required AlterarTemaUseCase alterar,
  })  : _carregar = carregar,
        _alterar = alterar;

  factory ThemeFacade.create(ThemeService service) {
    return ThemeFacade(
      carregar: CarregarTemaUseCase(service),
      alterar: AlterarTemaUseCase(service),
    );
  }

  Future<Result<bool>> carregarTema() => _carregar();
  Future<Result<bool>> alterarTema(bool isDark) => _alterar(isDark);
}
