// lib/domain/usecases/alterar_tema_usecase.dart

import '../../data/services/theme_service.dart';
import '../../core/patterns/result.dart';

class AlterarTemaUseCase {
  final ThemeService _service;
  AlterarTemaUseCase(this._service);

  Future<Result<bool>> call(bool isDark) async {
    try {
      await _service.salvarTema(isDark);
      return Success(isDark);
    } catch (e) {
      return const Failure('Erro ao salvar tema.');
    }
  }
}

class CarregarTemaUseCase {
  final ThemeService _service;
  CarregarTemaUseCase(this._service);

  Future<Result<bool>> call() async {
    try {
      final isDark = await _service.carregarTema();
      return Success(isDark);
    } catch (e) {
      return const Failure('Erro ao carregar tema.');
    }
  }
}
