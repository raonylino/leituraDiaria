import 'dart:convert';

class ContactsModel {
  final int? id; // Alterado para int
  final String livro;
  final String capitulo;

  ContactsModel({
    this.id, 
    required this.livro, 
    required this.capitulo,
    });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'livro': livro,
      'capitulo': capitulo,
    };
  }

  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
      id: map['id'] != null ? map['id'] as int : null, // Alterado para int
      livro: map['livro'] as String,
      capitulo: map['capitulo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactsModel.fromJson(String source) => ContactsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}