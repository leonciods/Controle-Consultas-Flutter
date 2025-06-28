class Receita {
  String id;
  String medicamento;
  String dosagem;
  String pacienteNome;
  String? observacoes;
  String? duracao;
  String dataEmissao;

  Receita({
    required this.id,
    required this.medicamento,
    required this.dosagem,
    required this.pacienteNome,
    required this.dataEmissao,
    this.observacoes,
    this.duracao,
  });

  Receita.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        medicamento = map["medicamento"],
        dosagem = map["dosagem"],
        pacienteNome = map["paciente_nome"],
        observacoes = map["observacoes"],
        duracao = map["duracao"],
        dataEmissao = map["data_emissao"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "medicamento": medicamento,
      "dosagem": dosagem,
      "paciente_nome": pacienteNome,
      "observacoes": observacoes,
      "duracao": duracao,
      "data_emissao": dataEmissao,
    };
  }
}