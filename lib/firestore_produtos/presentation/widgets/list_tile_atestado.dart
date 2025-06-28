import 'package:flutter/material.dart';
import '../../../firestone/models/atestado.dart';

class ListTileAtestado extends StatelessWidget {
  final Atestado atestado;
  final Function showModal;
  final Function onDelete;

  const ListTileAtestado({
    super.key,
    required this.atestado,
    required this.showModal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        onTap: () {
          showModal(model: atestado);
        },
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.assignment,
            color: Colors.orange,
            size: 24,
          ),
        ),
        title: Text(
          "Atestado - ${atestado.diasAfastamento} ${atestado.diasAfastamento == 1 ? 'dia' : 'dias'}",
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
              "CID: ${atestado.cid}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Período: ${_formatarDataSimples(atestado.dataInicio)} a ${_formatarDataSimples(atestado.dataFim)}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            if (atestado.observacoes != null && atestado.observacoes!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                "Obs: ${atestado.observacoes}",
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
              "Emitido em: ${_formatarData(atestado.dataEmissao)}",
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
                showModal(model: atestado);
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

  String _formatarDataSimples(String dataIso) {
    try {
      DateTime data = DateTime.parse(dataIso);
      return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
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
          content: Text('Deseja realmente excluir este atestado de ${atestado.diasAfastamento} ${atestado.diasAfastamento == 1 ? 'dia' : 'dias'}?'),
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
                onDelete(atestado);
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