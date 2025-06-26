// class TaskModel {
//   String id;
//   String text;
//   String photo;
//   int difficulty;
//   int nivel;
//   String listaId; // Para relacionar com uma lista específica
  
//   TaskModel({
//     required this.id,
//     required this.text,
//     required this.photo,
//     required this.difficulty,
//     this.nivel = 0,
//     required this.listaId,
//   });
  
//   // Converter para Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'text': text,
//       'photo': photo,
//       'difficulty': difficulty,
//       'nivel': nivel,
//       'listaId': listaId,
//     };
//   }
  
//   // Criar objeto do Map
//   factory TaskModel.fromMap(Map<String, dynamic> map) {
//     return TaskModel(
//       id: map['id'],
//       text: map['text'],
//       photo: map['photo'],
//       difficulty: map['difficulty'],
//       nivel: map['nivel'] ?? 0,
//       listaId: map['listaId'],
//     );
//   }
// }