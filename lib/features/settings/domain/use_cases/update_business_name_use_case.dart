import 'package:invoify/core/network/network_response.dart';
import '../repo/settings_repo.dart';

class UpdateBusinessNameUseCase {
  UpdateBusinessNameUseCase(this._settingsRepo);

  final SettingsRepo _settingsRepo;

  Future<NetworkResponse<void>> call({
    required String uid,
    required String businessName,
  }) async => await _settingsRepo.updateBusinessName(
    uid: uid,
    businessName: businessName,
  );
}
