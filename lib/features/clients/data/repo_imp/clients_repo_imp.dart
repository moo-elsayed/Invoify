import 'package:invoify/core/network/network_response.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/repo/clients_repo.dart';
import '../data_sources/remote/clients_remote_data_source.dart';
import '../models/client_model.dart';

class ClientsRepoImp implements ClientsRepo {
  ClientsRepoImp(this._remoteDataSource);

  final ClientsRemoteDataSource _remoteDataSource;

  @override
  Future<NetworkResponse<List<ClientEntity>>> getClients({
    required String userId,
  }) async {
    final response = await _remoteDataSource.getClients(userId: userId);
    switch (response) {
      case NetworkSuccess<List<ClientModel>>():
        final entities =
            (response.data ?? []).map((model) => model.toEntity()).toList();
        return NetworkSuccess(entities);
      case NetworkFailure<List<ClientModel>>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<ClientEntity>> addClient({
    required ClientEntity client,
  }) async {
    final model = ClientModel.fromEntity(client);
    final response = await _remoteDataSource.addClient(client: model);
    switch (response) {
      case NetworkSuccess<ClientModel>():
        return NetworkSuccess(response.data!.toEntity());
      case NetworkFailure<ClientModel>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<void>> updateClient({
    required ClientEntity client,
  }) async =>
      await _remoteDataSource.updateClient(client: ClientModel.fromEntity(client));

  @override
  Future<NetworkResponse<void>> deleteClient({
    required String clientId,
  }) async =>
      await _remoteDataSource.deleteClient(clientId: clientId);
}
