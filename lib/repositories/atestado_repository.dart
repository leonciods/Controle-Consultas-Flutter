import 'dart:convert';
import 'package:flutter_projeto1/http/exceptions.dart';
import 'package:flutter_projeto1/http/http_client_lista.dart';
import 'package:flutter_projeto1/firestone/models/atestado.dart';

abstract class IAtestadoRepository {
  Future<List<Atestado>> getAtestados(String consultaId);
  Future<Atestado> createAtestado(String consultaId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes, String? pacienteNome);
  Future<void> deleteAtestado(String consultaId, String atestadoId);
  Future<Atestado> updateAtestado(String consultaId, String atestadoId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes, String? pacienteNome);
}

class AtestadoRepository implements IAtestadoRepository {
  final IHttpClientLista client;
  AtestadoRepository({required this.client});

  @override
  Future<List<Atestado>> getAtestados(String consultaId) async {
    final response = await client.get(url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
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
  Future<Atestado> createAtestado(String consultaId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes, String? pacienteNome) async {
    // Validar campos obrigatórios antes de enviar
    if (consultaId.trim().isEmpty) {
      throw Exception('ID da consulta é obrigatório');
    }
    if (cid.trim().isEmpty) {
      throw Exception('CID é obrigatório');
    }
    if (diasAfastamento <= 0) {
      throw Exception('Dias de afastamento deve ser maior que zero');
    }
    if (dataInicio.trim().isEmpty) {
      throw Exception('Data de início é obrigatória');
    }
    if (dataFim.trim().isEmpty) {
      throw Exception('Data de fim é obrigatória');
    }

    final requestBody = {
      'cid': cid.trim().toUpperCase(),
      'dias_afastamento': diasAfastamento,
      'data_inicio': dataInicio.trim(),
      'data_fim': dataFim.trim(),
      'data_emissao': DateTime.now().toIso8601String(),
    };

    // Adicionar campos opcionais apenas se não estiverem vazios
    if (observacoes != null && observacoes.trim().isNotEmpty) {
      requestBody['observacoes'] = observacoes.trim();
    }
    
    if (pacienteNome != null && pacienteNome.trim().isNotEmpty) {
      requestBody['paciente_nome'] = pacienteNome.trim();
    }

    print('Enviando dados para API: ${jsonEncode(requestBody)}'); // Debug

    final response = await client.post(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados',
      body: jsonEncode(requestBody),
    );

    print('Resposta da API - Status: ${response.statusCode}'); // Debug
    print('Resposta da API - Body: ${response.body}'); // Debug

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Atestado.fromMap(data);
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception('Dados obrigatórios não informados: ${errorData['message'] ?? 'Erro desconhecido'}');
    } else if (response.statusCode == 404) {
      throw NotFoundException("Consulta não encontrada");
    } else {
      throw Exception('Não foi possível criar o atestado. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteAtestado(String consultaId, String atestadoId) async {
    final response = await client.delete(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados/$atestadoId',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return; // Atestado deletado com sucesso
    } else if (response.statusCode == 404) {
      throw NotFoundException("Atestado ou consulta não encontrada");
    } else {
      throw Exception('Não foi possível deletar o atestado');
    }
  }

  @override
  Future<Atestado> updateAtestado(String consultaId, String atestadoId, String cid, int diasAfastamento, String dataInicio, String dataFim, String? observacoes, String? pacienteNome) async {
    // Validar campos obrigatórios antes de enviar
    if (consultaId.trim().isEmpty) {
      throw Exception('ID da consulta é obrigatório');
    }
    if (atestadoId.trim().isEmpty) {
      throw Exception('ID do atestado é obrigatório');
    }
    if (cid.trim().isEmpty) {
      throw Exception('CID é obrigatório');
    }
    if (diasAfastamento <= 0) {
      throw Exception('Dias de afastamento deve ser maior que zero');
    }
    if (dataInicio.trim().isEmpty) {
      throw Exception('Data de início é obrigatória');
    }
    if (dataFim.trim().isEmpty) {
      throw Exception('Data de fim é obrigatória');
    }

    final requestBody = {
      'cid': cid.trim().toUpperCase(),
      'dias_afastamento': diasAfastamento,
      'data_inicio': dataInicio.trim(),
      'data_fim': dataFim.trim(),
      'data_emissao': DateTime.now().toIso8601String(),
    };

    // Adicionar campos opcionais apenas se não estiverem vazios
    if (observacoes != null && observacoes.trim().isNotEmpty) {
      requestBody['observacoes'] = observacoes.trim();
    }
    
    if (pacienteNome != null && pacienteNome.trim().isNotEmpty) {
      requestBody['paciente_nome'] = pacienteNome.trim();
    }

    final response = await client.update(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/atestados/$atestadoId',
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Atestado.fromMap(data);
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception('Dados inválidos informados: ${errorData['message'] ?? 'Erro desconhecido'}');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Atestado ou consulta não encontrada');
    } else {
      throw Exception('Não foi possível atualizar o atestado');
    }
  }
}