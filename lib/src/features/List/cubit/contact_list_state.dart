part of 'contact_list_cubit.dart';

@freezed
class ContactListState with _$ContactListState {
  const factory ContactListState.initial() = _Initial;
  const factory ContactListState.loading() = _Loading;
    const factory ContactListState.data(
    {required List<ContactsModel> contacts}) = _Data;
  const factory ContactListState.success() = _Success;
  const factory ContactListState.error(String message) = _Error;

}
