import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../student/aluno_viewmodel.dart';
import '../../domain/models/aluno_model.dart';

class RankingScreen extends StatelessWidget {
  final AlunoViewModel alunoViewModel;
  const RankingScreen({super.key, required this.alunoViewModel});

  Color _corPosicao(int posicao) {
    return switch (posicao) {
      1 => const Color(0xFFFFD700),
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => Colors.grey.shade400,
    };
  }

  Widget _buildMedal(int posicao) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _corPosicao(posicao),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$posicao',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final carregando = alunoViewModel.calcularRankingCommand.running.value;
      final lista = alunoViewModel.ranking.value;

      if (carregando) {
        return const Center(child: CircularProgressIndicator());
      }

      if (lista.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.leaderboard_outlined, size: 72, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Nenhum aluno no ranking ainda.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lista.length,
        itemBuilder: (_, i) {
          final aluno = lista[i];
          final posicao = i + 1;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: _buildMedal(posicao),
              title: Text(
                aluno.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '${aluno.apelido.isNotEmpty ? '"${aluno.apelido}" • ' : ''}${aluno.curso} ${aluno.turmaAno}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Nível Lenda',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '${aluno.nivelLenda} pts',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
