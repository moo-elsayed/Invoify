part of 'clients_cubit.dart';

abstract class ClientsState {}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsSuccess extends ClientsState {
  ClientsSuccess({required this.clients, required this.filteredClients});

  final List<ClientEntity> clients;
  final List<ClientEntity> filteredClients;
}

class ClientsFailure extends ClientsState {
  ClientsFailure(this.error);
  final String error;
}

class ClientActionLoading extends ClientsState {}

class ClientActionSuccess extends ClientsState {
  ClientActionSuccess(this.message);
  final String message;
}

class ClientActionFailure extends ClientsState {
  ClientActionFailure(this.error);
  final String error;
}
