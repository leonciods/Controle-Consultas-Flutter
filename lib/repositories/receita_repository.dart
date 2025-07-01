import 'dart:convert';
import 'package:flutter_projeto1/http/exceptions.dart';
import 'package:flutter_projeto1/http/http_client_lista.dart';
import 'package:flutter_projeto1/firestone/models/receita.dart';

abstract class IReceitaRepository {
  Future<List<Receita>> getReceitas(String consultaId);
  Future<Receita> createReceita(String consultaId, String medicamento, String dosagem, String pacienteNome, String? duracao, String? observacoes);
  Future<void> deleteReceita(String consultaId, String receitaId);
  Future<Receita> updateReceita(String consultaId, String receitaId, String medicamento, String dosagem, String pacienteNome, String? duracao, String? observacoes);
}

class ReceitaRepository implements IReceitaRepository {
  final IHttpClientLista client;
  ReceitaRepository({required this.client});

  @override
  Future<List<Receita>> getReceitas(String consultaId) async {
    final response = await client.get(url: 'http://127.0.0.1:5000/consultas/$consultaId/receitas');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Receita> receitas = [];
      for (var item in data) {
        receitas.add(Receita.fromMap(item));
      }
      return receitas;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception('Não foi possível carregar as receitas');
    }
  }

  @override
  Future<Receita> createReceita(String consultaId, String medicamento, String dosagem, String pacienteNome, String? duracao, String? observacoes) async {
    final response = await client.post(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/receitas',
      body: jsonEncode({
        'medicamento': medicamento,
        'dosagem': dosagem,
        'paciente_nome': pacienteNome, // ADICIONAR ESTE CAMPO
        'duracao': duracao,
        'observacoes': observacoes,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Receita.fromMap(data);
    } else if (response.statusCode == 400) {
      throw Exception('Dados obrigatórios não informados');
    } else if (response.statusCode == 404) {
      throw NotFoundException("Consulta não encontrada");
    } else {
      throw Exception('Não foi possível criar a receita');
    }
  }

  @override
  Future<void> deleteReceita(String consultaId, String receitaId) async {
    final response = await client.delete(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/receitas/$receitaId',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return; // Receita deletada com sucesso
    } else if (response.statusCode == 404) {
      throw NotFoundException("Receita ou consulta não encontrada");
    } else {
      throw Exception('Não foi possível deletar a receita');
    }
  }

  @override
  Future<Receita> updateReceita(String consultaId, String receitaId, String medicamento, String dosagem, String pacienteNome, String? duracao, String? observacoes) async {
    final response = await client.update(
      url: 'http://127.0.0.1:5000/consultas/$consultaId/receitas/$receitaId',
      body: jsonEncode({
        'medicamento': medicamento,
        'dosagem': dosagem,
        'paciente_nome': pacienteNome, // ADICIONAR ESTE CAMPO
        'duracao': duracao,
        'observacoes': observacoes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Receita.fromMap(data);
    } else if (response.statusCode == 400) {
      throw Exception('Dados inválidos informados');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Receita ou consulta não encontrada');
    } else {
      throw Exception('Não foi possível atualizar a receita');
    }
  }
}