// lib/data/services/aluno_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AlunoService {
  static const _key = 'pyramidgame_alunos';

  Future<void> salvarAlunos(List<Map<String, dynamic>> alunosJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(alunosJson));
  }

  Future<List<Map<String, dynamic>>> carregarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }
}
