import 'package:invoify/core/network/network_response.dart';

abstract class SettingsRepo {
  Future<NetworkResponse<void>> updateCurrency({
    required String uid,
    required String currency,
  });
}
