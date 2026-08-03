import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoify/core/network/api_helper.dart';
import 'package:invoify/core/network/network_response.dart';
import '../../models/client_model.dart';
import 'clients_remote_data_source.dart';

class ClientsRemoteDataSourceImp implements ClientsRemoteDataSource {
  ClientsRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _clientsCollection = 'clients';

  @override
  Future<NetworkResponse<List<ClientModel>>> getClients({
    required String userId,
  }) async => ApiHelper.executeSafely(() async {
    final querySnapshot = await _firestore
        .collection(_clientsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    final clients = querySnapshot.docs
        .map((doc) => ClientModel.fromJson(doc.data(), docId: doc.id))
        .toList();

    return clients;
  }, functionName: 'getClients');

  @override
  Future<NetworkResponse<ClientModel>> addClient({
    required ClientModel client,
  }) async => ApiHelper.executeSafely(() async {
    final docRef = _firestore.collection(_clientsCollection).doc();
    final newClient = ClientModel(
      clientId: docRef.id,
      userId: client.userId,
      name: client.name,
      email: client.email,
      phone: client.phone,
      address: client.address,
      createdAt: client.createdAt,
    );

    await docRef.set(newClient.toJson());
    return newClient;
  }, functionName: 'addClient');

  @override
  Future<NetworkResponse<void>> updateClient({
    required ClientModel client,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(_clientsCollection)
        .doc(client.clientId)
        .update(client.toJson());
  }, functionName: 'updateClient');

  @override
  Future<NetworkResponse<void>> deleteClient({
    required String clientId,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore.collection(_clientsCollection).doc(clientId).delete();
  }, functionName: 'deleteClient');
}
