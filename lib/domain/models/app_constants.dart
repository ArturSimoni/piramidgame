class AppConstants {
  AppConstants._();

  static const List<String> cursos = [
    'INFO',
    'MEC',
    'MAMB',
    'PROD',
    'TADS',
    'TGA',
  ];

  static List<int> get turmaAnos =>
      List.generate(2026 - 1998 + 1, (i) => 1998 + i);
}
