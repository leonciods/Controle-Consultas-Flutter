import 'package:flutter/material.dart';
import '../../../firestone/models/receita.dart';

class ListTileReceita extends StatelessWidget {
  final Receita receita;
  final Function showModal;
  final Function onDelete;

  const ListTileReceita({
    super.key,
    required this.receita,
    required this.showModal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        onTap: () {
          showModal(model: receita);
        },
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.medication,
            color: Colors.teal,
            size: 24,
          ),
        ),
        title: Text(
          receita.medicamento,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Dosagem: ${receita.dosagem}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (receita.duracao != null) ...[
              const SizedBox(height: 2),
              Text(
                "Duração: ${receita.duracao}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
            if (receita.observacoes != null && receita.observacoes!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                "Obs: ${receita.observacoes}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              "Emitida em: ${_formatarData(receita.dataEmissao)}",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (String value) {
            switch (value) {
              case 'editar':
                showModal(model: receita);
                break;
              case 'excluir':
                _showDeleteConfirmation(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'excluir',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatarData(String dataIso) {
    try {
      DateTime data = DateTime.parse(dataIso);
      return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Data inválida";
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir a receita de ${receita.medicamento}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(receita);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}