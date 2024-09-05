part of 'register_list_cubit.dart';

@freezed
class RegisterListState with _$RegisterListState {
  const factory RegisterListState.initial() = _Initial;
  const factory RegisterListState.success() = _Success;
  const factory RegisterListState.error(String message) = _Error;
  const factory RegisterListState.loading() = _Loading;
}
