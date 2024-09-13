import 'dart:convert';

class ContactsModel {
  final int? id; // Alterado para int
  final String livro;
  final int usuarioId;
  final int capituloInicio;
  final int capituloFim;
  final DateTime dataLeitura;
  late bool leituraCompleta;

  ContactsModel({
    this.id,
    required this.usuarioId, 
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
    id: map['id'] != null ? map['id'] as int : null,
    livro: map['livro'] != null ? map['livro'] as String : '',
    usuarioId: map['usuario_id'] != null ? map['usuario_id'] as int : 0,
    capituloInicio: map['capituloInicio'] != null ? map['capituloInicio'] as int : 0,
    capituloFim: map['capituloFim'] != null ? map['capituloFim'] as int : 0,
    dataLeitura: map['dataLeitura'] != null ? DateTime.parse(map['dataLeitura'] as String) : DateTime.now(),
    leituraCompleta: map['leituraCompleta'] != null ? map['leituraCompleta'] as bool : false,
  );
}

  String toJson() => json.encode(toMap());

  factory ContactsModel.fromJson(String source) => ContactsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}