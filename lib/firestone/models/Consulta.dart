class Consulta {
  String id;
  String pacienteNome;  
  String medicoNome; 
  DateTime dataConsulta;
  String anamnese;
  String diagnostico;
  String status;

  Consulta({
    required this.id,
    required this.pacienteNome,
    required this.medicoNome, 
    required this.dataConsulta,
    required this.anamnese,
    required this.diagnostico,
    required this.status
  });

  Consulta.fromMap(Map<String, dynamic> map)
      :  id = map["id"] ?? '',
        pacienteNome = map["paciente_nome"] ?? '', 
        medicoNome = map["medico_nome"] ?? '', 
        dataConsulta = map["data_consulta"] != null 
            ? DateTime.parse(map["data_consulta"])
            : DateTime.now(),
        anamnese = map["anamnese"] ?? '',
        diagnostico = map["diagnostico"] ?? '',
        status = map["status"] ?? '';

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "paciente_nome": pacienteNome,
      "medico_nome": medicoNome,
      "data_consulta": dataConsulta.toIso8601String(),       
      "anamnese": anamnese,
      "diagnostico": diagnostico,
      "status": status
    };
  }
}
