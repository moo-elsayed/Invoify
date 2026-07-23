import 'package:invoify/core/network/network_response.dart';
import '../../domain/repo/settings_repo.dart';
import '../data_sources/remote/settings_remote_data_source.dart';

class SettingsRepoImp implements SettingsRepo {
  SettingsRepoImp(this._settingsRemoteDataSource);

  final SettingsRemoteDataSource _settingsRemoteDataSource;

  @override
  Future<NetworkResponse<void>> updateCurrency({
    required String uid,
    required String currency,
  }) async => await _settingsRemoteDataSource.updateCurrency(
    uid: uid,
    currency: currency,
  );
}
