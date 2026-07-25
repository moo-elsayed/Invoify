import 'package:invoify/core/network/network_response.dart';
import '../../models/client_model.dart';

abstract class ClientsRemoteDataSource {
  Future<NetworkResponse<List<ClientModel>>> getClients({
    required String userId,
  });

  Future<NetworkResponse<ClientModel>> addClient({
    required ClientModel client,
  });

  Future<NetworkResponse<void>> updateClient({
    required ClientModel client,
  });

  Future<NetworkResponse<void>> deleteClient({
    required String clientId,
  });
}
