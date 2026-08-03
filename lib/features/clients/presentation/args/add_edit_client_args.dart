import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';

class AddEditClientArgs {
  const AddEditClientArgs({this.client, required this.cubit});

  final ClientEntity? client;
  final ClientsCubit cubit;
}
