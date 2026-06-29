import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';
import 'package:intl/intl.dart';
import 'aluno_viewmodel.dart';
import '../../domain/facades/aluno_facade.dart';
import '../../data/repositories/aluno_repository.dart';
import '../../data/services/aluno_service.dart';
import '../../domain/models/aluno_model.dart';

class StudentDetailScreen extends StatefulWidget {
  final String alunoId;
  const StudentDetailScreen({super.key, required this.alunoId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late final AlunoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final service = AlunoService();
    final repo = AlunoRepository(service);
    _viewModel = AlunoViewModel(AlunoFacade.create(repo));
    _viewModel.buscarPorIdCommand.execute(widget.alunoId);
  }

  void _confirmarRemocao(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover aluno'),
        content: const Text('Deseja realmente remover este aluno?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _viewModel.removerCommand.execute(id);
              if (mounted) context.pop();
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCriterio(String key, int nota) {
    final label = Aluno.criteriosLabels[key] ?? key;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < nota ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$nota', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Aluno'),
      ),
      body: Watch((context) {
        final carregando = _viewModel.buscarPorIdCommand.running.value;

        if (carregando) {
          return const Center(child: CircularProgressIndicator());
        }

        final aluno = _viewModel.alunoSelecionado.value;
        if (aluno == null) {
          return const Center(child: Text('Aluno não encontrado.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          aluno.nome[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        aluno.nome,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (aluno.apelido.isNotEmpty)
                        Text(
                          '"${aluno.apelido}"',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text(aluno.curso)),
                          Chip(label: Text('${aluno.turmaAno}')),
                          Chip(
                            label: Text(DateFormat('dd/MM/yyyy')
                                .format(aluno.dataNascimento)),
                            avatar: const Icon(Icons.cake, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              'Nível Lenda: ${aluno.nivelLenda} pts',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Critérios de Popularidade',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 20),
                      ...Aluno.criteriosKeys.map(
                          (key) => _buildCriterio(key, aluno.notas[key] ?? 1)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context
                          .push('/aluno/editar', extra: aluno.id)
                          .then((_) => _viewModel.buscarPorIdCommand
                              .execute(widget.alunoId)),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmarRemocao(aluno.id),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remover'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
