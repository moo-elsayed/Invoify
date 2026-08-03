import 'package:invoify/core/network/network_response.dart';
import '../entities/client_entity.dart';

abstract class ClientsRepo {
  Future<NetworkResponse<List<ClientEntity>>> getClients({
    required String userId,
  });

  Future<NetworkResponse<ClientEntity>> addClient({
    required ClientEntity client,
  });

  Future<NetworkResponse<void>> updateClient({required ClientEntity client});

  Future<NetworkResponse<void>> deleteClient({required String clientId});
}
