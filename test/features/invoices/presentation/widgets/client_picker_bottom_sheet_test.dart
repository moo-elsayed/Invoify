import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_bottom_sheet.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_bottom_sheet_tile.dart';
import 'package:invoify/features/invoices/presentation/widgets/client_picker_skeleton_list.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockClientsCubit extends MockCubit<ClientsState>
    implements ClientsCubit {}

void main() {
  late MockClientsCubit mockClientsCubit;

  final tClients = [
    const ClientEntity(
      clientId: 'c1',
      name: 'John Doe',
      email: 'john@example.com',
    ),
    const ClientEntity(
      clientId: 'c2',
      name: 'Jane Smith',
      email: 'jane@example.com',
    ),
  ];

  setUp(() {
    mockClientsCubit = MockClientsCubit();
    when(() => mockClientsCubit.state).thenReturn(ClientsInitial());
    when(() => mockClientsCubit.allClients).thenReturn([]);
  });

  group('ClientPickerBottomSheet Tests', () {
    testWidgets('renders skeleton list when ClientsLoading and list is empty', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(ClientsLoading());
      when(() => mockClientsCubit.allClients).thenReturn([]);

      await tester.pumpWidget(
        createWidgetForTesting(
          child: BlocProvider<ClientsCubit>.value(
            value: mockClientsCubit,
            child: ClientPickerBottomSheet(
              selectedClient: null,
              onClientSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ClientPickerSkeletonList), findsOneWidget);
    });

    testWidgets('renders noClientsAvailable text when clients list is empty', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsSuccess(clients: const [], filteredClients: const []),
      );
      when(() => mockClientsCubit.allClients).thenReturn([]);

      await tester.pumpWidget(
        createWidgetForTesting(
          child: BlocProvider<ClientsCubit>.value(
            value: mockClientsCubit,
            child: ClientPickerBottomSheet(
              selectedClient: null,
              onClientSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.noClientsAvailable), findsOneWidget);
    });

    testWidgets(
      'renders list of ClientPickerBottomSheetTiles and triggers onClientSelected when tapped',
      (WidgetTester tester) async {
        when(() => mockClientsCubit.state).thenReturn(
          ClientsSuccess(clients: tClients, filteredClients: tClients),
        );
        when(() => mockClientsCubit.allClients).thenReturn(tClients);

        ClientEntity? selected;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<ClientsCubit>.value(
              value: mockClientsCubit,
              child: ClientPickerBottomSheet(
                selectedClient: null,
                onClientSelected: (client) => selected = client,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ClientPickerBottomSheetTile), findsNWidgets(2));
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Jane Smith'), findsOneWidget);

        await tester.tap(find.text('John Doe'));
        expect(selected?.name, equals('John Doe'));
      },
    );
  });
}
