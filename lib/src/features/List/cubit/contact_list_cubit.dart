import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/repositories/contacts_repository.dart';
part 'contact_list_state.dart';
part 'contact_list_cubit.freezed.dart';

class ContactListCubit extends Cubit<ContactListState> {

  final ContactsRepository _repository;

  ContactListCubit(
    {required ContactsRepository repository,}):
    _repository = repository,
    super(const ContactListState.initial());

  Future<void> findAll() async {
    emit(const ContactListState.loading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final contacts = await _repository.findAll();
      emit(ContactListState.data(contacts: contacts));
    } catch (e,s) {
      log('Erro ao buscar contatos', error: e , stackTrace: s);
      emit(const ContactListState.error('Erro ao buscar Leituras'));
    }
  }

  Future<void> save(ContactsModel model) async {
    try {
      await _repository.updateLeitura(model);
      findAll();
    } catch (e,s) {
      log('Erro ao salvar Versiculos', error: e , stackTrace: s);
      emit(const ContactListState.error('Erro ao salvar Versiculos'));
    }
  }
  
    Future<void> deleteByModel(ContactsModel model) async {
    try {
      emit(const ContactListState.loading());
      await Future.delayed(const Duration(seconds: 2));
      await _repository.delete(model);
      findAll();
    } catch (e,s) {
      log('Erro ao deletar Versiculos', error: e , stackTrace: s);
      emit(const ContactListState.error('Erro ao deletar Versiculos'));
    }
  }
  

}


