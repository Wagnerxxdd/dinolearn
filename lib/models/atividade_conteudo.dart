class AtividadeConteudo {
  final String id;
  final String tipo;
  final String pergunta;
  final String? instrucaoAudio;
  final String? imagem;
  final List<Alternativa> alternativas;
  final String respostaCorreta;
  final String? dicaErro1;
  final String? apoioErro2;

  AtividadeConteudo({
    required this.id,
    required this.tipo,
    required this.pergunta,
    this.instrucaoAudio,
    this.imagem,
    required this.alternativas,
    required this.respostaCorreta,
    this.dicaErro1,
    this.apoioErro2,
  });

  factory AtividadeConteudo.fromJson(Map<String, dynamic> json) {
    return AtividadeConteudo(
      id: json['id'],
      tipo: json['tipo'],
      pergunta: json['pergunta'],
      instrucaoAudio: json['instrucao_audio'],
      imagem: json['imagem'],
      alternativas: (json['alternativas'] as List)
          .map((item) => Alternativa.fromJson(item))
          .toList(),
      respostaCorreta: json['resposta_correta'],
      dicaErro1: json['dica_erro_1'],
      apoioErro2: json['apoio_erro_2'],
    );
  }
}

class Alternativa {
  final String id;
  final String texto;

  Alternativa({required this.id, required this.texto});

  factory Alternativa.fromJson(Map<String, dynamic> json) {
    return Alternativa(
      id: json['id'],
      texto: json['texto'],
    );
  }
}
