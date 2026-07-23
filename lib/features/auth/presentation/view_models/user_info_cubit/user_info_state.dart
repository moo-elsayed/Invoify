part of 'user_info_cubit.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoSuccess extends UserInfoState {
  UserInfoSuccess(this.user);
  final UserEntity user;
}

class UserInfoFailure extends UserInfoState {
  UserInfoFailure(this.error);
  final String error;
}

class UserUpdateSuccess extends UserInfoState {
  UserUpdateSuccess({required this.user, required this.message});
  final UserEntity user;
  final String message;
}

class UserUpdateFailure extends UserInfoState {
  UserUpdateFailure({required this.user, required this.error});
  final UserEntity user;
  final String error;
}
