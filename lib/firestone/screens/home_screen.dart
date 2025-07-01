import 'package:flutter/material.dart';
import 'package:flutter_projeto1/firestone/screens/criar_consulta_screen.dart';

class HomeScreen extends StatelessWidget {

  Widget _selectedCleaning(Color color, String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.only(left: 20,),
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title, style: TextStyle(
            fontSize: 22, color: Colors.white,
          )
        ),
        SizedBox(height: 5,
        ),
        
      ]
      )
    );    
  }

  Widget _seletedExtras(String image, String name, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey, width: 2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage
                  (image: AssetImage(image)),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              name, style: TextStyle(
                fontSize: 17,
              )
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
        title: Text(
          'UPA - Aplicativo do(a) Médico(a)',
          style: TextStyle(
            fontSize: 23,            
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Container(
          height: 800,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Conteúdo existente em um Expanded
              Expanded(
                child: ListView(           
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30),
                      child: Text("Bem-vindo(a)!",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(padding: EdgeInsets.only(
                        left: 30, 
                        top:30,
                        ),
                        child: Row(
                          children: [
                            _selectedCleaning(
                              Colors.teal,
                              "Acessar lista de pacientes",
                            ),
                          ],)
                        )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30, 
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selecione a ação', style: TextStyle(
                              fontSize: 20, color: Colors.black,  )
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20,
                            ),
                            child: Container(
                              height: 300,
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.30,
                                children: [
                                  _seletedExtras(
                                    '../assets/images/consulta.png',
                                    'Criar consulta',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CriarConsultaScreen(openModalOnStart: true),
                                        ),
                                      );
                                    },
                                  ),
                                  _seletedExtras(
                                    '../assets/images/receita.png',
                                    'Consultas criadas',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CriarConsultaScreen(openModalOnStart: false),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          )
                        ],
                      )
                    ),
                  ]
                ),
              ),
              // Imagem do SUS fixada na parte inferior
              Container(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  '../assets/images/logo-sus.png',
                  height: 120,
                  width: 120,
                ),
              ),
            ],
          )
        )
      )
    );
  }
}