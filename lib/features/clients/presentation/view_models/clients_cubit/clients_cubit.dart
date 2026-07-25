import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/use_cases/add_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/delete_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/update_client_use_case.dart';

part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit(
    this._getClientsUseCase,
    this._addClientUseCase,
    this._updateClientUseCase,
    this._deleteClientUseCase,
  ) : super(ClientsInitial());

  final GetClientsUseCase _getClientsUseCase;
  final AddClientUseCase _addClientUseCase;
  final UpdateClientUseCase _updateClientUseCase;
  final DeleteClientUseCase _deleteClientUseCase;

  List<ClientEntity> _allClients = [];
  String _currentSearchQuery = '';

  List<ClientEntity> get allClients => _allClients;

  Future<void> getClients() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    emit(ClientsLoading());

    final response = await _getClientsUseCase(firebaseUser.uid);
    switch (response) {
      case NetworkSuccess<List<ClientEntity>>():
        _allClients = response.data ?? [];
        _emitClientsSuccess();
      case NetworkFailure<List<ClientEntity>>():
        emit(ClientsFailure(response.error));
    }
  }

  void searchClients(String query) {
    _currentSearchQuery = query.trim().toLowerCase();
    _emitClientsSuccess();
  }

  void _emitClientsSuccess() {
    if (_currentSearchQuery.isEmpty) {
      emit(ClientsSuccess(
        clients: _allClients,
        filteredClients: List.from(_allClients),
      ));
    } else {
      final filtered = _allClients.where((client) {
        final nameMatch = client.name.toLowerCase().contains(_currentSearchQuery);
        final emailMatch = client.email.toLowerCase().contains(_currentSearchQuery);
        final phoneMatch = client.phone.toLowerCase().contains(_currentSearchQuery);
        final addressMatch = client.address.toLowerCase().contains(_currentSearchQuery);
        return nameMatch || emailMatch || phoneMatch || addressMatch;
      }).toList();

      emit(ClientsSuccess(
        clients: _allClients,
        filteredClients: filtered,
      ));
    }
  }

  Future<void> addClient({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    emit(ClientActionLoading());

    final client = ClientEntity(
      userId: firebaseUser.uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      createdAt: DateTime.now(),
    );

    final response = await _addClientUseCase(client);
    switch (response) {
      case NetworkSuccess<ClientEntity>():
        if (response.data != null) {
          _allClients.insert(0, response.data!);
        }
        emit(ClientActionSuccess(AppStrings.clientAddedSuccessfully));
        _emitClientsSuccess();
      case NetworkFailure<ClientEntity>():
        emit(ClientActionFailure(response.error));
    }
  }

  Future<void> updateClient(ClientEntity updatedClient) async {
    emit(ClientActionLoading());

    final response = await _updateClientUseCase(updatedClient);
    switch (response) {
      case NetworkSuccess<void>():
        final index = _allClients.indexWhere(
          (c) => c.clientId == updatedClient.clientId,
        );
        if (index != -1) {
          _allClients[index] = updatedClient;
        }
        emit(ClientActionSuccess(AppStrings.clientUpdatedSuccessfully));
        _emitClientsSuccess();
      case NetworkFailure<void>():
        emit(ClientActionFailure(response.error));
    }
  }

  Future<void> deleteClient(String clientId) async {
    emit(ClientActionLoading());

    final response = await _deleteClientUseCase(clientId);
    switch (response) {
      case NetworkSuccess<void>():
        _allClients.removeWhere((c) => c.clientId == clientId);
        emit(ClientActionSuccess(AppStrings.clientDeletedSuccessfully));
        _emitClientsSuccess();
      case NetworkFailure<void>():
        emit(ClientActionFailure(response.error));
    }
  }
}
