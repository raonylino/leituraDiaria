import 'dart:developer';

import 'package:oceans/main.dart';
import 'package:oceans/src/models/contacts_model.dart';

class ContactsRepository {
  Future<List<ContactsModel>> findAll() async {
    try {

     final response =  await supabase.rpc('get_livros_lidos',
     params: {'user_id' : supabase.auth.currentUser!.id}
     ).select();
    log('RPC: $response');
      // // final response = await supabase.from('livros').select();
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      List<ContactsModel> contacts = data
          .map<ContactsModel>((contact) => ContactsModel.fromMap(contact))
          .toList();

      contacts.sort((a, b) => a.dataLeitura.compareTo(b.dataLeitura));

      return contacts;
    } catch (e) {
      throw Exception('Erro ao buscar contatos: $e');
    }
  }

  Future<void> create(ContactsModel model) async {
    try {
      await supabase.from('livros').insert(model.toMap());
    } catch (e) {
      throw Exception('Erro ao criar contato: $e');
    }
  }

  Future<void> update(ContactsModel model) async => await supabase
      .from('livros')
      .update(model.toMap())
      .eq('id', '${model.id}');

  Future<void> updateLeitura(ContactsModel model) async {
    await supabase
        .from('livros')
        .update(model.toMap())
        .eq('id', model.id as Object);
  }

  Future<void> delete(ContactsModel model) async =>
      await supabase.from('livros').delete().eq('id', '${model.id}');
}
