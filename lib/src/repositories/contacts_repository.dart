import 'package:oceans/main.dart';
import 'package:oceans/src/models/contacts_model.dart';

class ContactsRepository {
  Future<List<ContactsModel>> findAll() async {
    try {
    final response = await supabase.from('leituras').select();

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
      await supabase.from('leituras').insert(model.toMap());
    } catch (e) {
      throw Exception('Erro ao criar contato: $e');
    }
  }

  Future<void> update(ContactsModel model) async => 
  await supabase.from('leituras').update(model.toMap()).eq('id','${model.id}');

  Future<void> updateLeitura(ContactsModel model) async =>
  await supabase.from('leituras').update(model.toMap()).eq('id','${model.id}');

  Future<void> delete(ContactsModel model) async =>
      await supabase.from('leituras').delete().eq('id','${model.id}');
}
