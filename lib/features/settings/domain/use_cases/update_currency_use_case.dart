import 'package:invoify/core/network/network_response.dart';
import '../repo/settings_repo.dart';

class UpdateCurrencyUseCase {
  UpdateCurrencyUseCase(this._settingsRepo);

  final SettingsRepo _settingsRepo;

  Future<NetworkResponse<void>> call({
    required String uid,
    required String currency,
  }) async =>
      await _settingsRepo.updateCurrency(uid: uid, currency: currency);
}
