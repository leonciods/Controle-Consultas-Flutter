import 'dart:convert';
import 'package:flutter_projeto1/http/exceptions.dart';
import 'package:flutter_projeto1/http/http_client_lista.dart';
import 'package:flutter_projeto1/firestone/models/atestado.dart';

abstract class IAtestadoRepository {
  Future<List<Atestado>> getAtestados(String consultaId);
  Future<Atestado> createAtestado(String consultaId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes);
  Future<void> deleteAtestado(String consultaId, String atestadoId);
  Future<Atestado> updateAtestado(String consultaId, String atestadoId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes);
}

class AtestadoRepository implements IAtestadoRepository {
  final IHttpClientLista client;
  AtestadoRepository({required this.client});

  @override
  Future<List<Atestado>> getAtestados(String consultaId) async {
    final response = await client.get(url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Atestado> atestados = [];
      for (var item in data) {
        atestados.add(Atestado.fromMap(item));
      }
      return atestados;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception('Não foi possível carregar os atestados');
    }
  }

  @override
  Future<Atestado> createAtestado(String consultaId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes) async {
    final response = await client.post(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados',
      body: jsonEncode({
        'cid': cid,
        'dias_afastamento': diasAfastamento,
        'data_inicio': dataInicio,
        'data_fim': dataFim,
        'observacoes': observacoes,
        'data_emissao': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Atestado.fromMap(data);
    } else if (response.statusCode == 400) {
      throw Exception('Dados obrigatórios não informados');
    } else if (response.statusCode == 404) {
      throw NotFoundException("Consulta não encontrada");
    } else {
      throw Exception('Não foi possível criar o atestado');
    }
  }

  @override
  Future<void> deleteAtestado(String consultaId, String atestadoId) async {
    final response = await client.delete(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados/$atestadoId',
    );

    if (response.statusCode == 204) {
      return; // Atestado deletado com sucesso
    } else if (response.statusCode == 404) {
      throw NotFoundException("Atestado ou consulta não encontrada");
    } else {
      throw Exception('Não foi possível deletar o atestado');
    }
  }

  @override
  Future<Atestado> updateAtestado(String consultaId, String atestadoId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes) async {
    final response = await client.update(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados/$atestadoId',
      body: jsonEncode({
        'cid': cid,
        'dias_afastamento': diasAfastamento,
        'data_inicio': dataInicio,
        'data_fim': dataFim,
        'observacoes': observacoes,
        'data_emissao': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Atestado.fromMap(data);
    } else if (response.statusCode == 400) {
      throw Exception('Dados inválidos informados');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Atestado ou consulta não encontrada');
    } else {
      throw Exception('Não foi possível atualizar o atestado');
    }
  }
}