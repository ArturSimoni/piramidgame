// lib/main.dart

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/theme_service.dart';

// Signal global de tema — observado pelo MaterialApp
final _isDarkMode = signal<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega o tema salvo antes de exibir o app
  final isDark = await ThemeService().carregarTema();
  _isDarkMode.value = isDark;

  runApp(const PiramidGameApp());
}

class PiramidGameApp extends StatelessWidget {
  const PiramidGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return MaterialApp.router(
        title: 'PiramidGame IFPR',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        routerConfig: appRouter,
      );
    });
  }
}

// Expõe o signal para que o ThemeViewModel possa atualizá-lo globalmente
Signal<bool> get globalIsDarkMode => _isDarkMode;
