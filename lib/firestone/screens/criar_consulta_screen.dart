import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projeto1/firestone/models/Consulta.dart';
import 'package:flutter_projeto1/firestore_produtos/presentation/receita_screen.dart';
import 'package:flutter_projeto1/http/http_client_lista.dart';
import 'package:flutter_projeto1/repositories/consulta_repository.dart';
//import 'package:uuid/uuid.dart';

class CriarConsultaScreen extends StatefulWidget {
  final bool openModalOnStart;
  const CriarConsultaScreen({super.key, this.openModalOnStart = false});

  @override
  State<CriarConsultaScreen> createState() => _CriarConsultaScreenState();
}

class _CriarConsultaScreenState extends State<CriarConsultaScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Consulta> listConsultas = [];

  @override
  void initState() {
    refresh();
    super.initState();

    if (widget.openModalOnStart) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showFormModal();
    });
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
        title: Text("Consultas criadas", 
        style: TextStyle(
            fontSize: 23,            
          ),)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body:
          (listConsultas.isEmpty)
              ? const Center(
                //child: Text(
                  //"Nenhuma consulta! Bora criar?!",
                  //textAlign: TextAlign.center,
                  //style: TextStyle(fontSize: 20),
                //),
              )
              : RefreshIndicator(
                onRefresh: () {
                  return refresh();
                },
                child: ListView(
                  children: List.generate(listConsultas.length, (index) {
                    Consulta model = listConsultas[index];
                    return Dismissible(
                      key: ValueKey<Consulta>(model),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutoScreen(lista: model),
                            ),
                          );
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                          //print("Clicou pressionado");
                        },
                        leading: Icon(Icons.list_alt_rounded),
                        title: Text(model.pacienteNome),
                        subtitle: Text(model.id),
                     ),
                  );
                }),
              ),
            ),
    );
  }


  showFormModal({Consulta? model}) {
    //Labels
    String title = "Adicionar Consulta";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // controlador do campo texto
    TextEditingController nameController = TextEditingController(); 
    TextEditingController medicoController = TextEditingController();   
    TextEditingController anamneseController = TextEditingController();
    TextEditingController diagnosticoController = TextEditingController();
    TextEditingController statusController = TextEditingController();


    if (model != null) {
      title = "Editando ${model.pacienteNome}";
      nameController.text = model.pacienteNome;
      medicoController.text = model.medicoNome;
      anamneseController.text = model.anamnese; 
      diagnosticoController.text = model.diagnostico; 
      statusController.text = model.status;
    }
    //Função que exibe o modal
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),
          //formulario com título, campo e botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(label: Text("Nome da paciente")),
              ),
              TextFormField(
                controller: medicoController,
                decoration: const InputDecoration(label: Text("Nome do médico")),
              ),
              TextFormField(
                controller: anamneseController,
                decoration: const InputDecoration(label: Text("Anamnese")),
              ),
              TextFormField(
                controller: diagnosticoController,
                decoration: const InputDecoration(label: Text("Diagnóstico")),
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(label: Text("Status")),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  SizedBox(width: 18),
                  ElevatedButton(
                    onPressed: () {
                      
                      createConsulta(                        
                        nameController.text,
                        medicoController.text,
                        anamneseController.text,
                        diagnosticoController.text,
                        statusController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                 ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void>refresh() async {
   /* List<Lista> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("listas").get();
    for (var doc in snapshot.docs) {
      temp.add(Lista.fromMap(doc.data()));
    }

    setState(() {
      listLista = temp;
    });*/

    try {
      final listaRepository = ConsultaRepository(client: HttpClientLista());
      final consultas = await listaRepository.getConsultas();
      setState(() {
        listConsultas = consultas;
      });
    } catch (e) {
      print('Erro ao carregar listas: $e');
    }


  }

  

  Future<void> createConsulta(String pacienteNome, String medicoNome, String anamnese, String diagnostico, String status) async { // CORRIGIDO: incluir medicoNome
    try {
      final consultaRepository = ConsultaRepository(client: HttpClientLista()); // CORRIGIDO: nome da classe
      await consultaRepository.createConsulta(pacienteNome, medicoNome, anamnese, diagnostico, status); // CORRIGIDO: método e parâmetros
      refresh();
    } catch (e) {
      print('Erro ao criar consulta: $e');
    }
  }

  void remove(Consulta model) {
    firestore.collection("consultas").doc(model.id).delete();
    refresh();
   }
}