import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/repositories/contacts_repository.dart';

part 'register_list_state.dart';
part 'register_list_cubit.freezed.dart';

class RegisterListCubit extends Cubit<RegisterListState> {

  final ContactsRepository _repository;

  RegisterListCubit({required ContactsRepository repository}):
  _repository = repository,
  super(const RegisterListState.initial());

    Future<void> register(ContactsModel contact) async {
    emit(const RegisterListState.loading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _repository.create(contact);
      emit(const RegisterListState.success());
    } catch (e,s) {
      log('Erro ao registrar Leitura', error: e , stackTrace: s);
      emit(const RegisterListState.error('Erro ao registrar Leitura'));
    }
  }
}
