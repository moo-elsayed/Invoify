import 'package:invoify/core/network/network_response.dart';
import '../entities/client_entity.dart';
import '../repo/clients_repo.dart';

class AddClientUseCase {
  AddClientUseCase(this._clientsRepo);

  final ClientsRepo _clientsRepo;

  Future<NetworkResponse<ClientEntity>> call(ClientEntity client) async =>
      await _clientsRepo.addClient(client: client);
}
