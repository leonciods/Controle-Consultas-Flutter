import 'package:uuid/uuid.dart';

class Atestado {
  String id;
  String pacienteNome;
  String cid;
  int diasAfastamento;
  String dataInicio;
  String dataFim;
  String? observacoes;
  String dataEmissao;

  Atestado({
    required this.id,
    required this.pacienteNome,
    required this.cid,
    required this.diasAfastamento,
    required this.dataInicio,
    required this.dataFim,
    required this.dataEmissao,
    this.observacoes,
  });

  Atestado.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        pacienteNome = map["paciente_nome"],
        cid = map["cid"],
        diasAfastamento = map["dias_afastamento"],
        dataInicio = map["data_inicio"],
        dataFim = map["data_fim"],
        observacoes = map["observacoes"],
        dataEmissao = map["data_emissao"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "paciente_nome": pacienteNome,
      "cid": cid,
      "dias_afastamento": diasAfastamento,
      "data_inicio": dataInicio,
      "data_fim": dataFim,
      "observacoes": observacoes,
      "data_emissao": dataEmissao,
    };
  }

  // Método para calcular automaticamente a data fim
  static String calcularDataFim(String dataInicio, int diasAfastamento) {
    try {
      DateTime inicio = DateTime.parse(dataInicio);
      DateTime fim = inicio.add(Duration(days: diasAfastamento - 1));
      return fim.toIso8601String().split('T')[0]; // Retorna apenas a data
    } catch (e) {
      return dataInicio;
    }
  }
}