import 'dart:convert';
import 'package:flutter_projeto1/http/exceptions.dart';
import 'package:flutter_projeto1/http/http_client_lista.dart';
import 'package:flutter_projeto1/firestone/models/Consulta.dart';


abstract class IConsultaRepository  {
  Future<List<Consulta>> getConsultas();
  Future<Consulta> createConsulta(String pacienteNome, String medicoNome, String anamnese, String diagnostico, String status); 
  Future<void> deleteConsulta(String id);
  Future<void> updateConsulta(String id, String pacienteNome, String medicoNome, String anamnese, String diagnostico, String status); 
  
}

class ConsultaRepository implements IConsultaRepository { // CORRIGIDO: nome da classe
  final IHttpClientLista client;
  ConsultaRepository({required this.client});

  @override
  Future<List<Consulta>> getConsultas() async {
    final response = await client.get(url: 'http://127.0.0.1:5000/consultas');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Consulta> consultas = []; 
      for (var item in data) {
        consultas.add(Consulta.fromMap(item));
      }

      return consultas;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception('Não foi possível carregar as consultas');
    }
  }

   @override
  Future<Consulta> createConsulta(String pacienteNome, String medicoNome, String anamnese, String diagnostico, String status) async {
    final response = await client.post(
      url: 'http://127.0.0.1:5000/consultas',
      body: jsonEncode({
        'paciente_nome': pacienteNome, // CORRIGIDO: usar paciente_nome da API
        'medico_nome': medicoNome, // ADICIONADO: campo obrigatório na API
        'data_consulta': DateTime.now().toIso8601String(),
        'anamnese': anamnese,
        'diagnostico': diagnostico,
        'status': status
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Consulta.fromMap(data);
    } else if (response.statusCode == 400) {
      throw Exception('Dados obrigatórios não informados');
    } else {
      throw Exception('Não foi possível criar a consulta');
    }
  }

  @override
  Future<void> deleteConsulta(String id) async {
    final response = await client.delete(
      url: 'http://127.0.0.1:5000/consultas/$id',
    );

    if (response.statusCode == 204) {
      return; // Consulta deletada com sucesso
    } else if (response.statusCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception('Não foi possível deletar a consulta');
    }
}

  @override
    Future<Consulta> updateConsulta(String id, String pacienteNome, String medicoNome, String anamnese, String diagnostico, String status) async {
      final response = await client.update(
        url: 'http://127.0.0.1:5000/consultas/$id',
        body: jsonEncode({
        'paciente_nome': pacienteNome, 
        'medico_nome': medicoNome, 
        'data_consulta': DateTime.now().toIso8601String(),
        'anamnese': anamnese,
        'diagnostico': diagnostico,
        'status': status
          }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Consulta.fromMap(data);
      } else if (response.statusCode == 400) {
        throw Exception(
          'ID da lista deve ser um UUID v4 válido ou Nome é obrigatório',
        );
      } else if (response.statusCode == 404) {
        throw NotFoundException('Lista não encontrada');
      } else {
        throw Exception('Não foi possível atualizar a lista');
      }
    }

}