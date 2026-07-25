import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoify/core/network/api_helper.dart';
import 'package:invoify/core/network/network_response.dart';
import 'settings_remote_data_source.dart';

class SettingsRemoteDataSourceImp implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _usersCollection = 'users';

  @override
  Future<NetworkResponse<void>> updateCurrency({
    required String uid,
    required String currency,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'currency': currency,
    });
  }, functionName: 'updateCurrency');

  @override
  Future<NetworkResponse<void>> updateBusinessName({
    required String uid,
    required String businessName,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'businessName': businessName,
    });
  }, functionName: 'updateBusinessName');
}
