import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projeto1/firestone/models/Consulta.dart';
import 'package:flutter_projeto1/firestone/models/receita.dart';
import 'package:flutter_projeto1/firestone/models/atestado.dart';
import 'package:flutter_projeto1/firestore_produtos/presentation/widgets/list_tile_atestado.dart';
import 'package:flutter_projeto1/firestore_produtos/presentation/widgets/list_tile_receita.dart';
import 'package:uuid/uuid.dart';


class ReceitaScreen extends StatefulWidget {
  final Consulta consulta;
  const ReceitaScreen({super.key, required this.consulta});

  @override
  State<ReceitaScreen> createState() => _ReceitaScreenState();
}

class _ReceitaScreenState extends State<ReceitaScreen> {
  List<Receita> listaReceitas = [];
  List<Atestado> listaAtestados = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
        title: Text(
          widget.consulta.pacienteNome,
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "receita",
            onPressed: () {
              showFormModal();
            },
            backgroundColor: Colors.teal,
            child: const Icon(Icons.medication),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "atestado",
            onPressed: () {
              showAtestadoModal();
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.assignment),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              "Receitas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: List.generate(listaReceitas.length, (index) {
                Receita receita = listaReceitas[index];
                return ListTileReceita(
                  receita: receita,
                  showModal: showFormModal,
                  onDelete: deleteReceita,
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              "Atestados",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: List.generate(listaAtestados.length, (index) {
                Atestado atestado = listaAtestados[index];
                return ListTileAtestado(
                  atestado: atestado,
                  showModal: showAtestadoModal,
                  onDelete: deleteAtestado,
                );
              }),
            ),
            if (listaAtestados.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Nenhum atestado emitido",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  showFormModal({Receita? model}) {
    // Labels a serem mostradas no Modal
    String labelTitle = "Criar Receita";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controladores dos campos da receita
    TextEditingController medicamentoController = TextEditingController();
    TextEditingController dosagemController = TextEditingController();
    TextEditingController observacoesController = TextEditingController();
    TextEditingController duracaoController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      labelTitle = "Editando Receita";
      medicamentoController.text = model.medicamento;
      dosagemController.text = model.dosagem;
      observacoesController.text = model.observacoes ?? '';
      duracaoController.text = model.duracao ?? '';
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(labelTitle, style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: medicamentoController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text("Medicamento*"),
                  icon: Icon(Icons.medication),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dosagemController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text("Dosagem*"),
                  icon: Icon(Icons.straighten),
                  hintText: "Ex: 500mg, 2 comprimidos",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: duracaoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text("Duração"),
                  icon: Icon(Icons.schedule),
                  hintText: "Ex: 7 dias, 2 semanas",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacoesController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                  label: Text("Observações"),
                  icon: Icon(Icons.note),
                  hintText: "Instruções adicionais",
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Validação básica
                      if (medicamentoController.text.trim().isEmpty ||
                          dosagemController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Medicamento e dosagem são obrigatórios'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Criar um objeto Receita com as infos
                      Receita receita = Receita(
                        id: model?.id ?? const Uuid().v4(),
                        medicamento: medicamentoController.text.trim(),
                        dosagem: dosagemController.text.trim(),
                        pacienteNome: widget.consulta.pacienteNome,
                        dataEmissao: DateTime.now().toIso8601String(),
                        observacoes: observacoesController.text.trim().isEmpty 
                            ? null 
                            : observacoesController.text.trim(),
                        duracao: duracaoController.text.trim().isEmpty 
                            ? null 
                            : duracaoController.text.trim(),
                      );

                      // Salvar no Firestore
                      firestore
                          .collection("consultas")
                          .doc(widget.consulta.id)
                          .collection("receitas")
                          .doc(receita.id)
                          .set(receita.toMap())
                          .then((_) {
                        // Atualizar a lista
                        refresh();
                        
                        // Mostrar mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(model == null 
                                ? 'Receita criada com sucesso!' 
                                : 'Receita atualizada com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        
                        // Fechar o Modal
                        Navigator.pop(context);
                      }).catchError((error) {
                        // Mostrar erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao salvar receita: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Receita> tempReceitas = await buscarReceitas();
    List<Atestado> tempAtestados = await buscarAtestados();

    setState(() {
      listaReceitas = tempReceitas;
      listaAtestados = tempAtestados;
    });
  }

  Future<List<Receita>> buscarReceitas() async {
    List<Receita> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("consultas")
          .doc(widget.consulta.id)
          .collection("receitas")
          .orderBy("data_emissao", descending: true)
          .get();

      for (var doc in snapshot.docs) {
        Receita receita = Receita.fromMap(doc.data());
        temp.add(receita);
      }
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar receitas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return temp;
  }

  deleteReceita(Receita receita) async {
    try {
      await firestore
          .collection("consultas")
          .doc(widget.consulta.id)
          .collection("receitas")
          .doc(receita.id)
          .delete();

      // Atualizar a lista
      refresh();

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receita excluída com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir receita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Métodos para Atestados
  showAtestadoModal({Atestado? model}) {
    String labelTitle = "Criar Atestado";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController cidController = TextEditingController();
    TextEditingController diasController = TextEditingController();
    TextEditingController dataInicioController = TextEditingController();
    TextEditingController observacoesController = TextEditingController();

    // Preencher com data atual por padrão
    DateTime hoje = DateTime.now();
    dataInicioController.text = "${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}";

    if (model != null) {
      labelTitle = "Editando Atestado";
      cidController.text = model.cid;
      diasController.text = model.diasAfastamento.toString();
      dataInicioController.text = model.dataInicio.split('T')[0];
      observacoesController.text = model.observacoes ?? '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              Text(labelTitle, style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: cidController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  label: Text("CID*"),
                  icon: Icon(Icons.medical_information),
                  hintText: "Ex: Z76.3, M54.5",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: diasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Dias de afastamento*"),
                  icon: Icon(Icons.calendar_today),
                  hintText: "Ex: 3, 7, 15",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dataInicioController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  label: Text("Data de início*"),
                  icon: Icon(Icons.date_range),
                  hintText: "AAAA-MM-DD",
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? data = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (data != null) {
                    dataInicioController.text = "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacoesController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                  label: Text("Observações"),
                  icon: Icon(Icons.note),
                  hintText: "Informações adicionais",
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (cidController.text.trim().isEmpty ||
                          diasController.text.trim().isEmpty ||
                          dataInicioController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('CID, dias de afastamento e data de início são obrigatórios'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      int diasAfastamento = int.tryParse(diasController.text.trim()) ?? 0;
                      if (diasAfastamento <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dias de afastamento deve ser um número válido maior que 0'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      String dataFim = Atestado.calcularDataFim(dataInicioController.text.trim(), diasAfastamento);

                      Atestado atestado = Atestado(
                        id: model?.id ?? const Uuid().v4(),
                        pacienteNome: widget.consulta.pacienteNome,
                        cid: cidController.text.trim().toUpperCase(),
                        diasAfastamento: diasAfastamento,
                        dataInicio: dataInicioController.text.trim(),
                        dataFim: dataFim,
                        dataEmissao: DateTime.now().toIso8601String(),
                        observacoes: observacoesController.text.trim().isEmpty 
                            ? null 
                            : observacoesController.text.trim(),
                      );

                      firestore
                          .collection("consultas")
                          .doc(widget.consulta.id)
                          .collection("atestados")
                          .doc(atestado.id)
                          .set(atestado.toMap())
                          .then((_) {
                        refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(model == null 
                                ? 'Atestado criado com sucesso!' 
                                : 'Atestado atualizado com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao salvar atestado: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Atestado>> buscarAtestados() async {
    List<Atestado> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("consultas")
          .doc(widget.consulta.id)
          .collection("atestados")
          .orderBy("data_emissao", descending: true)
          .get();

      for (var doc in snapshot.docs) {
        Atestado atestado = Atestado.fromMap(doc.data());
        temp.add(atestado);
      }
    } catch (e) {
      print('Erro ao buscar atestados: $e');
    }

    return temp;
  }

  deleteAtestado(Atestado atestado) async {
    try {
      await firestore
          .collection("consultas")
          .doc(widget.consulta.id)
          .collection("atestados")
          .doc(atestado.id)
          .delete();

      refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atestado excluído com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir atestado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}