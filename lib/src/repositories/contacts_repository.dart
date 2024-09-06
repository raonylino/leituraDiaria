import 'package:dio/dio.dart';
import 'package:oceans/src/models/contacts_model.dart';

class ContactsRepository {


Future<List<ContactsModel>> findAll() async {
  try {
    final response = await Dio().get("http://10.0.2.2:3031/leituras");
    List<ContactsModel> contacts = (response.data as List)
        .map<ContactsModel>((contact) => ContactsModel.fromMap(contact))
        .toList();
    contacts.sort((a, b) => a.dataLeitura.compareTo(b.dataLeitura));

    return contacts;
  } catch (e) {
    throw Exception('Erro ao buscar contatos: $e');
  }
}

  Future <void> create(ContactsModel model) async {
    try{
      await Dio().post("http://10.0.2.2:3031/leituras",data: model.toMap());
    } catch (e) {
      throw Exception('Erro ao criar contato: $e');
    }
  }
  
  Future <void> update(ContactsModel model) async =>
    Dio().put('http://10.0.2.2:3031/leituras/${model.id}', data: model.toMap());

    Future <void> updateLeitura(ContactsModel model) async =>
    Dio().put('http://10.0.2.2:3031/leituras/${model.id}', data: model.toMap());  

  Future <void> delete(ContactsModel model) async =>
    Dio().delete('http://10.0.2.2:3031/leituras/${model.id}');  
}
