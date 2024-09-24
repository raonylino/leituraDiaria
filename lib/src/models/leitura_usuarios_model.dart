class LeituraUsuariosModel {
  final int id;
  final String titulo;
  final bool lido;

  LeituraUsuariosModel({required this.id, required this.titulo, required this.lido});

  factory LeituraUsuariosModel.fromJson(Map<String, dynamic> json) => LeituraUsuariosModel(
    id: json['id'],
    titulo: json['livro'],
    lido: json['lido'],
  );
}