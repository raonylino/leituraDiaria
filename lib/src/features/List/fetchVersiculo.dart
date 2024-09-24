// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oceans/src/models/versiculo_model.dart';

Future<Versiculo> fetchVersiculo() async {
  final response = await http.get(
    Uri.parse('https://bolls.life/get-random-verse/NVT/'),
  );
  if (response.statusCode == 200) {
    return Versiculo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao carregar versículo');
  }
}