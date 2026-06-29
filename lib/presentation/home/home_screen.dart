import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';
import '../student/aluno_viewmodel.dart';
import '../home/theme_viewmodel.dart';
import '../../domain/facades/aluno_facade.dart';
import '../../domain/facades/theme_facade.dart';
import '../../data/repositories/aluno_repository.dart';
import '../../data/services/aluno_service.dart';
import '../../data/services/theme_service.dart';
import '../../domain/models/aluno_model.dart';
import '../ranking/ranking_screen.dart';
import '../about/about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AlunoViewModel alunoViewModel;
  late final ThemeViewModel themeViewModel;
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    final service = AlunoService();
    final repo = AlunoRepository(service);
    final facade = AlunoFacade.create(repo);
    alunoViewModel = AlunoViewModel(facade);

    final themeService = ThemeService();
    themeViewModel = ThemeViewModel(ThemeFacade.create(themeService));

    themeViewModel.carregarTemaCommand.execute();
    alunoViewModel.carregarAlunosCommand.execute();
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
            onPressed: () {
              Navigator.pop(context);
              alunoViewModel.removerCommand.execute(id);
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAlunos() {
    return Watch((context) {
      final carregando = alunoViewModel.carregarAlunosCommand.running.value;
      final lista = alunoViewModel.alunos.value;

      if (carregando) {
        return const Center(child: CircularProgressIndicator());
      }

      if (lista.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_outlined, size: 72, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Nenhum aluno cadastrado ainda.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
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
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  aluno.nome[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(aluno.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  '${aluno.apelido.isNotEmpty ? '"${aluno.apelido}" • ' : ''}${aluno.curso} ${aluno.turmaAno}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        '${aluno.nivelLenda}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'ver') {
                        context
                            .push('/aluno/detalhe', extra: aluno.id)
                            .then((_) =>
                                alunoViewModel.carregarAlunosCommand.execute());
                      } else if (v == 'editar') {
                        context
                            .push('/aluno/editar', extra: aluno.id)
                            .then((_) =>
                                alunoViewModel.carregarAlunosCommand.execute());
                      } else if (v == 'remover') {
                        _confirmarRemocao(aluno.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'ver', child: Text('Ver detalhes')),
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(
                          value: 'remover',
                          child:
                              Text('Remover', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
              onTap: () => context
                  .push('/aluno/detalhe', extra: aluno.id)
                  .then((_) => alunoViewModel.carregarAlunosCommand.execute()),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isDark = themeViewModel.isDarkMode.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('PiramidGame IFPR'),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Alternar tema',
              onPressed: () => themeViewModel.toggleTemaCommand.execute(),
            ),
          ],
        ),
        body: IndexedStack(
          index: _paginaAtual,
          children: [
            _buildListaAlunos(),
            RankingScreen(alunoViewModel: alunoViewModel),
            const AboutScreen(),
          ],
        ),
        floatingActionButton: _paginaAtual == 0
            ? FloatingActionButton.extended(
                onPressed: () => context
                    .push('/aluno/novo')
                    .then((_) => alunoViewModel.carregarAlunosCommand.execute()),
                icon: const Icon(Icons.add),
                label: const Text('Novo Aluno'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _paginaAtual,
          onDestinationSelected: (i) {
            setState(() => _paginaAtual = i);
            if (i == 1) alunoViewModel.calcularRankingCommand.execute();
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: 'Alunos'),
            NavigationDestination(
                icon: Icon(Icons.leaderboard_outlined),
                selectedIcon: Icon(Icons.leaderboard),
                label: 'Ranking'),
            NavigationDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: 'Sobre'),
          ],
        ),
      );
    });
  }
}
