// lib/presentation/home/theme_viewmodel.dart

import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/facades/theme_facade.dart';
import '../../main.dart';

class ThemeViewModel {
  final ThemeFacade _facade;

  ThemeViewModel(this._facade) {
    toggleTemaCommand = Command0(_toggleTema);
    carregarTemaCommand = Command0(_carregarTema);
  }

  // Usa o signal global para que o MaterialApp reaja
  get isDarkMode => globalIsDarkMode;

  late final Command0<bool> toggleTemaCommand;
  late final Command0<bool> carregarTemaCommand;

  Future<Result<bool>> _carregarTema() async {
    final result = await _facade.carregarTema();
    if (result is Success) {
      globalIsDarkMode.value = (result as Success<bool>).data;
    }
    return result;
  }

  Future<Result<bool>> _toggleTema() async {
    final novo = !globalIsDarkMode.value;
    final result = await _facade.alterarTema(novo);
    if (result is Success) {
      globalIsDarkMode.value = novo;
    }
    return result;
  }
}
