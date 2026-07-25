import 'package:invoify/core/network/network_response.dart';
import '../entities/client_entity.dart';
import '../repo/clients_repo.dart';

class UpdateClientUseCase {
  UpdateClientUseCase(this._clientsRepo);

  final ClientsRepo _clientsRepo;

  Future<NetworkResponse<void>> call(ClientEntity client) async =>
      await _clientsRepo.updateClient(client: client);
}
