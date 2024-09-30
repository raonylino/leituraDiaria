import 'dart:convert';

class ContactsModel {
  final int? id; 
  final String livro;
  final int capituloInicio;
  final int capituloFim;
  final DateTime dataLeitura;
  late bool leituraCompleta;

  ContactsModel({
    this.id,
    required this.livro, 
    required this.capituloInicio, 
    required this.capituloFim, 
    required this.dataLeitura,
    this.leituraCompleta = false,
    });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'livro': livro,
      'capituloInicio': capituloInicio,
      'capituloFim': capituloFim,
      'dataLeitura': dataLeitura.toIso8601String(),
      'leituraCompleta': leituraCompleta
    };
  }

factory ContactsModel.fromMap(Map<String, dynamic> map) {
  return ContactsModel(
    id: map['livro_id'] != null ? map['livro_id'] as int : null,
    livro: map['titulo'] != null ? map['titulo'] as String : '',
    capituloInicio: map['inicio'] != null ? map['inicio'] as int : 0,
    capituloFim: map['fim'] != null ? map['fim'] as int : 0,
    dataLeitura: map['data'] != null ? DateTime.parse(map['data'] as String) : DateTime.now(),
    leituraCompleta: map['lido'] != null ? map['lido'] as bool : false,
  );
}

  String toJson() => json.encode(toMap());

  factory ContactsModel.fromJson(String source) => ContactsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}