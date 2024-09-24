import 'dart:developer';

import 'package:oceans/main.dart';
import 'package:oceans/src/models/contacts_model.dart';

class ContactsRepository {
  Future<List<ContactsModel>> findAll() async {
    try {
     final rpc =  await supabase.rpc('sql', params: {
        'sql': '''
SELECT
  l.id AS livro_id,
  l.livro AS titulo,
  l."capituloInicio" AS inicio,
  l."capituloInicio" AS fim,
  l."dataLeitura" AS data,
  CASE WHEN lu.id IS NULL THEN false ELSE true END AS lido
FROM
  livros l
  LEFT JOIN leituras_usuarios lu ON l.id = lu.leitura_id AND lu.usuario_id = 'dcbe9958-2a06-4517-b0bf-d5f6c0408cdb'
;'''
      }).select();
    log('RPC: $rpc');
      // // final response = await supabase.from('livros').select();
      // List<Map<String, dynamic>> data =
      //     List<Map<String, dynamic>>.from(response);

      // List<ContactsModel> contacts = data
      //     .map<ContactsModel>((contact) => ContactsModel.fromMap(contact))
      //     .toList();

      // contacts.sort((a, b) => a.dataLeitura.compareTo(b.dataLeitura));

      return rpc.map<ContactsModel>((map) => ContactsModel.fromMap(map)).toList();
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
