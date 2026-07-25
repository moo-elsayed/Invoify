import 'package:invoify/core/network/network_response.dart';

abstract class SettingsRepo {
  Future<NetworkResponse<void>> updateCurrency({
    required String uid,
    required String currency,
  });

  Future<NetworkResponse<void>> updateBusinessName({
    required String uid,
    required String businessName,
  });
}
