import 'package:invoify/core/network/network_response.dart';
import '../entities/client_entity.dart';
import '../repo/clients_repo.dart';

class GetClientsUseCase {
  GetClientsUseCase(this._clientsRepo);

  final ClientsRepo _clientsRepo;

  Future<NetworkResponse<List<ClientEntity>>> call(String userId) async =>
      await _clientsRepo.getClients(userId: userId);
}
