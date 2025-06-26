import 'package:flutter/material.dart';
import 'package:flutter_projeto1/components/difficulty.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_application_1/models/lista.dart';
//import 'package:uuid/uuid.dart';

class Task extends StatefulWidget {
  final String text;
  final String photo;
  final int difficulty;
  final int nivel;

  const Task([
    this.text = '',
    this.photo = '',
    this.difficulty = 0,
    this.nivel = 0,
    Key? key,
  ]) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int nivel = 0;
  @override
  void initState() {
    super.initState();
    nivel = widget.nivel;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              height: 140,
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black26,
                        ),
                        width: 72,
                        height: 100,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child:
                              widget.photo.startsWith('http')
                                  ? Image.network(
                                    widget.photo,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    widget.photo,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Difficulty(difficultyLevel: widget.difficulty),
                        ],
                      ),
                      Container(
                        width: 66,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              98,
                              199,
                              135,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            if (nivel < 10) {
                              setState(() {
                                nivel++;
                              });
                              //FirebaseFirestore firestore = FirebaseFirestore.instance;
                              // firestore
                              //.collection("tarefas")
                              //.doc(widget.text)
                              //.set({
                              //  'nivel': nivel,
                              //  });
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_drop_up),
                              Text('UP', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 400,
                        child: LinearProgressIndicator(
                          color: Colors.white,
                          value: nivel / 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Nível: $nivel',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
