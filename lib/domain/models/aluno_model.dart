class Aluno {
  final String id;
  final String nome;
  final String apelido;
  final String curso;
  final int turmaAno;
  final DateTime dataNascimento;
  final Map<String, int> notas;

  Aluno({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.curso,
    required this.turmaAno,
    required this.dataNascimento,
    required this.notas,
  });

  int get nivelLenda => notas.values.fold(0, (sum, nota) => sum + nota);

  // Lista dos 15 critérios na ordem do documento
  static const List<String> criteriosKeys = [
    'resenha',
    'presenca_vip',
    'aura',
    'modo_parceiro',
    'carisma_natural',
    'humor_de_milhoes',
    'energia_de_grupo',
    'criatividade_caotica',
    'modo_atleta',
    'talento_de_palco',
    'drip_escolar',
    'coracao_de_dorama',
    'queridinho_professores',
    'cerebro_turbo',
    'caos_controlado',
  ];

  static const Map<String, String> criteriosLabels = {
    'resenha': 'Resenha',
    'presenca_vip': 'Presença VIP',
    'aura': 'Aura',
    'modo_parceiro': 'Modo Parceiro',
    'carisma_natural': 'Carisma Natural',
    'humor_de_milhoes': 'Humor de Milhões',
    'energia_de_grupo': 'Energia de Grupo',
    'criatividade_caotica': 'Criatividade Caótica',
    'modo_atleta': 'Modo Atleta',
    'talento_de_palco': 'Talento de Palco',
    'drip_escolar': 'Drip Escolar',
    'coracao_de_dorama': 'Coração de Dorama',
    'queridinho_professores': 'Queridinho dos Professores',
    'cerebro_turbo': 'Cérebro Turbo',
    'caos_controlado': 'Caos Controlado',
  };

  static Map<String, int> notasIniciais() =>
      {for (var k in criteriosKeys) k: 1};

  Aluno copyWith({
    String? id,
    String? nome,
    String? apelido,
    String? curso,
    int? turmaAno,
    DateTime? dataNascimento,
    Map<String, int>? notas,
  }) {
    return Aluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      curso: curso ?? this.curso,
      turmaAno: turmaAno ?? this.turmaAno,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      notas: notas ?? this.notas,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'apelido': apelido,
        'curso': curso,
        'turmaAno': turmaAno,
        'dataNascimento': dataNascimento.toIso8601String(),
        'notas': notas,
      };

  factory Aluno.fromJson(Map<String, dynamic> json) => Aluno(
        id: json['id'],
        nome: json['nome'],
        apelido: json['apelido'] ?? '',
        curso: json['curso'],
        turmaAno: json['turmaAno'],
        dataNascimento: DateTime.parse(json['dataNascimento']),
        notas: Map<String, int>.from(json['notas']),
      );
}
