import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/use_cases/get_user_info_use_case.dart';
import 'package:invoify/features/settings/domain/use_cases/update_currency_use_case.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit(
    this._appPreferencesService,
    this._getUserInfoUseCase,
    this._updateCurrencyUseCase,
  ) : super(UserInfoInitial()) {
    loadCachedUser();
  }

  final AppPreferencesService _appPreferencesService;
  final GetUserInfoUseCase _getUserInfoUseCase;
  final UpdateCurrencyUseCase _updateCurrencyUseCase;

  UserEntity? get currentUser {
    if (state is UserInfoSuccess) {
      return (state as UserInfoSuccess).user;
    } else if (state is UserUpdateSuccess) {
      return (state as UserUpdateSuccess).user;
    } else if (state is UserUpdateFailure) {
      return (state as UserUpdateFailure).user;
    }
    return _appPreferencesService.getUser();
  }

  void loadCachedUser() {
    final cachedUser = _appPreferencesService.getUser();
    if (cachedUser != null) {
      emit(UserInfoSuccess(cachedUser));
    }
  }

  Future<void> getUserInfo() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final cached = currentUser;
    if (cached == null) {
      emit(UserInfoLoading());
    }

    final response = await _getUserInfoUseCase(firebaseUser.uid);
    switch (response) {
      case NetworkSuccess<UserEntity>():
        if (response.data != null) {
          final updatedUser = response.data!;
          await _appPreferencesService.saveUser(updatedUser);
          emit(UserInfoSuccess(updatedUser));
        }
      case NetworkFailure<UserEntity>():
        if (cached == null) {
          emit(UserInfoFailure(response.error));
        }
    }
  }

  Future<void> updateCurrency(String newCurrency) async {
    final user = currentUser;
    if (user == null) return;

    final updatedUser = user.copyWith(currency: newCurrency);
    await saveUserLocally(updatedUser);

    final response = await _updateCurrencyUseCase(
      uid: user.uid,
      currency: newCurrency,
    );

    switch (response) {
      case NetworkSuccess<void>():
        emit(UserUpdateSuccess(
          user: updatedUser,
          message: AppStrings.currencyUpdated,
        ));
      case NetworkFailure<void>():
        await saveUserLocally(user);
        emit(UserUpdateFailure(
          user: user,
          error: response.error,
        ));
    }
  }

  Future<void> saveUserLocally(UserEntity user) async {
    await _appPreferencesService.saveUser(user);
    emit(UserInfoSuccess(user));
  }

  Future<void> clearUserLocally() async {
    await _appPreferencesService.clearUser();
    emit(UserInfoInitial());
  }
}
