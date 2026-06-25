// lib/presentation/student/student_form_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'aluno_viewmodel.dart';
import '../../domain/facades/aluno_facade.dart';
import '../../data/repositories/aluno_repository.dart';
import '../../data/services/aluno_service.dart';
import '../../domain/models/aluno_model.dart';
import '../../domain/models/app_constants.dart';
import '../../core/patterns/result.dart' as r;

class StudentFormScreen extends StatefulWidget {
  final String? alunoId;
  const StudentFormScreen({super.key, this.alunoId});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  late final AlunoViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  final _nomeCtrl = TextEditingController();
  final _apelidoCtrl = TextEditingController();
  String? _cursoSelecionado;
  int? _anoSelecionado;
  DateTime? _dataNascimento;
  final Map<String, int> _notas = Aluno.notasIniciais();

  bool get _editando => widget.alunoId != null;

  @override
  void initState() {
    super.initState();
    final service = AlunoService();
    final repo = AlunoRepository(service);
    _viewModel = AlunoViewModel(AlunoFacade.create(repo));

    if (_editando) {
      _viewModel.buscarPorIdCommand.execute(widget.alunoId!).then((_) {
        final aluno = _viewModel.alunoSelecionado.value;
        if (aluno != null) _preencherFormulario(aluno);
      });
    }
  }

  void _preencherFormulario(Aluno aluno) {
    setState(() {
      _nomeCtrl.text = aluno.nome;
      _apelidoCtrl.text = aluno.apelido;
      _cursoSelecionado = aluno.curso;
      _anoSelecionado = aluno.turmaAno;
      _dataNascimento = aluno.dataNascimento;
      aluno.notas.forEach((k, v) => _notas[k] = v);
    });
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dataNascimento = picked);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de nascimento.')),
      );
      return;
    }

    final aluno = Aluno(
      id: _editando ? widget.alunoId! : const Uuid().v4(),
      nome: _nomeCtrl.text.trim(),
      apelido: _apelidoCtrl.text.trim(),
      curso: _cursoSelecionado!,
      turmaAno: _anoSelecionado!,
      dataNascimento: _dataNascimento!,
      notas: Map.from(_notas),
    );

    if (_editando) {
      await _viewModel.alterarCommand.execute(aluno);
    } else {
      await _viewModel.cadastrarCommand.execute(aluno);
    }

    final result = _editando
        ? _viewModel.alterarCommand.result.value
        : _viewModel.cadastrarCommand.result.value;

    if (!mounted) return;

    if (result is r.Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text((result as r.Failure).message),
            backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editando ? 'Aluno atualizado!' : 'Aluno cadastrado!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  Widget _buildStarRating(String key) {
    final label = Aluno.criteriosLabels[key] ?? key;
    final nota = _notas[key] ?? 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Row(
            children: List.generate(5, (i) {
              final estrela = i + 1;
              return GestureDetector(
                onTap: () => setState(() => _notas[key] = estrela),
                child: Icon(
                  estrela <= nota ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 28,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _apelidoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Aluno' : 'Novo Aluno'),
      ),
      body: Watch((context) {
        final carregando = _viewModel.cadastrarCommand.running.value ||
            _viewModel.alterarCommand.running.value ||
            _viewModel.buscarPorIdCommand.running.value;

        if (carregando && _editando && _nomeCtrl.text.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('Dados do Aluno'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'O nome é obrigatório.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apelidoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Apelido',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _cursoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Curso *',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                items: AppConstants.cursos
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _cursoSelecionado = v),
                validator: (v) => v == null ? 'Selecione um curso.' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _anoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Turma/Ano *',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                items: AppConstants.turmaAnos.reversed
                    .map((a) => DropdownMenuItem(value: a, child: Text('$a')))
                    .toList(),
                onChanged: (v) => setState(() => _anoSelecionado = v),
                validator: (v) =>
                    v == null ? 'Selecione o ano da turma.' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento *',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  child: Text(
                    _dataNascimento != null
                        ? DateFormat('dd/MM/yyyy').format(_dataNascimento!)
                        : 'Toque para selecionar',
                    style: TextStyle(
                      color: _dataNascimento != null
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Critérios de Popularidade'),
              const SizedBox(height: 4),
              Text(
                'Avalie de 1 a 5 estrelas em cada critério.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ...Aluno.criteriosKeys.map(_buildStarRating),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Nível Lenda: ${_notas.values.fold(0, (s, v) => s + v)} pontos',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: carregando ? null : _salvar,
                icon: carregando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label:
                    Text(_editando ? 'Salvar Alterações' : 'Cadastrar Aluno'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
