import 'package:invoify/core/network/network_response.dart';
import '../repo/clients_repo.dart';

class DeleteClientUseCase {
  DeleteClientUseCase(this._clientsRepo);

  final ClientsRepo _clientsRepo;

  Future<NetworkResponse<void>> call(String clientId) async =>
      await _clientsRepo.deleteClient(clientId: clientId);
}
