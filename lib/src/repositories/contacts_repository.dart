import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:oceans/main.dart';
import 'package:oceans/src/models/contacts_model.dart';

class ContactsRepository {
  Future<List<ContactsModel>> findAll() async {
    try {
    final response = await supabase.from('leituras').select();

      log('Response type: ${response.runtimeType}');

      // Converta o response para uma lista de mapas
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

          log('Data after conversion: $data');

      List<ContactsModel> contacts = data
          .map<ContactsModel>((contact) => ContactsModel.fromMap(contact))
          .toList();

      // contacts.sort((a, b) => a.dataLeitura.compareTo(b.dataLeitura));
      log('Contacts list: $contacts');
      return contacts;
    } catch (e) {
      log('Erro ao buscar contatos: $e');
      throw Exception('Erro ao buscar contatos: $e');
    }
  }

  Future<void> create(ContactsModel model) async {
    try {
      await supabase.from('lista_leitura').insert(model.toMap());
    } catch (e) {
      throw Exception('Erro ao criar contato: $e');
    }
  }

  Future<void> update(ContactsModel model) async => 
  await supabase.from('lista_leitura').update(model.toMap());

  Future<void> updateLeitura(ContactsModel model) async => Dio()
      .put('http://10.0.2.2:3031/leituras/${model.id}', data: model.toMap());

  Future<void> delete(ContactsModel model) async =>
      Dio().delete('http://10.0.2.2:3031/leituras/${model.id}');
}
