// lib/presentation/about/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
                const SizedBox(height: 8),
                Text(
                  'PiramidGame',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Text(
                  'IFPR – Campus Paranaguá',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSecao(
            context,
            'Objetivo',
            'O Ranking de Popularidade dos Alunos é um aplicativo desenvolvido em '
                'Flutter para fins didáticos. Ele permite cadastrar alunos do IFPR – '
                'Campus Paranaguá e avaliá-los em critérios descontraídos de '
                'convivência, destaque e participação na turma.',
          ),
          _buildSecao(
            context,
            'Como funciona',
            'Cada aluno recebe notas de 1 a 5 estrelas em 15 categorias. '
                'A soma dessas notas forma o Nível Lenda, usado para organizar '
                'o ranking geral. A pontuação varia de 15 (mínimo) a 75 (máximo) pontos.',
          ),
          _buildSecao(
            context,
            'Critérios avaliados',
            '1. Resenha\n2. Presença VIP\n3. Aura\n4. Modo Parceiro\n'
                '5. Carisma Natural\n6. Humor de Milhões\n7. Energia de Grupo\n'
                '8. Criatividade Caótica\n9. Modo Atleta\n10. Talento de Palco\n'
                '11. Drip Escolar\n12. Coração de Dorama\n'
                '13. Queridinho dos Professores\n14. Cérebro Turbo\n'
                '15. Caos Controlado',
          ),
          _buildSecao(
            context,
            'Armazenamento',
            'Todos os dados são armazenados localmente no dispositivo utilizando '
                'SharedPreferences. Nenhuma informação é enviada para servidores externos.',
          ),
          _buildSecao(
            context,
            'Tema',
            'O aplicativo suporta tema claro e tema escuro. '
                'Alterne usando o ícone na barra superior.',
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Desenvolvido para a disciplina de Dispositivos Móveis',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSecao(BuildContext context, String titulo, String conteudo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(conteudo, style: const TextStyle(fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
