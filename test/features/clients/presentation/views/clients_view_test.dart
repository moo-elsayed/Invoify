import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/views/clients_view.dart';
import 'package:invoify/features/clients/presentation/widgets/client_card.dart';
import 'package:invoify/features/clients/presentation/widgets/client_search_bar.dart';
import 'package:invoify/features/clients/presentation/widgets/client_skeleton_list.dart';
import 'package:invoify/features/clients/presentation/widgets/empty_clients_widget.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockClientsCubit extends MockCubit<ClientsState>
    implements ClientsCubit {}

void main() {
  late MockClientsCubit mockClientsCubit;

  final tClients = [
    const ClientEntity(
      clientId: 'c1',
      name: 'Acme Corp',
      email: 'info@acme.com',
      phone: '+111111',
    ),
    const ClientEntity(
      clientId: 'c2',
      name: 'Stark Industries',
      email: 'tony@stark.com',
      phone: '+222222',
    ),
  ];

  setUp(() {
    mockClientsCubit = MockClientsCubit();
    when(() => mockClientsCubit.state).thenReturn(ClientsInitial());
    when(() => mockClientsCubit.allClients).thenReturn([]);
  });

  Widget buildTestableWidget() => createWidgetForTesting(
        child: BlocProvider<ClientsCubit>.value(
          value: mockClientsCubit,
          child: const ClientsView(),
        ),
      );

  group('ClientsView Widget Tests', () {
    testWidgets('renders skeleton loading list when state is ClientsLoading', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(ClientsLoading());

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(ClientSkeletonList), findsOneWidget);
    });

    testWidgets('renders EmptyClientsWidget when state is ClientsSuccess with empty list', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsSuccess(clients: const [], filteredClients: const []),
      );
      when(() => mockClientsCubit.allClients).thenReturn([]);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(EmptyClientsWidget), findsOneWidget);
      expect(find.text(AppStrings.noClientsYet), findsOneWidget);
    });

    testWidgets('renders CustomErrorWidget when state is ClientsFailure', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsFailure('Failed to load clients'),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text('Failed to load clients'), findsOneWidget);
    });

    testWidgets('renders list of ClientCards when state is ClientsSuccess with clients', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsSuccess(clients: tClients, filteredClients: tClients),
      );
      when(() => mockClientsCubit.allClients).thenReturn(tClients);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ClientCard), findsNWidgets(2));
      expect(find.text('Acme Corp'), findsOneWidget);
      expect(find.text('Stark Industries'), findsOneWidget);
    });

    testWidgets('calls searchClients on cubit when user types query in ClientSearchBar', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsSuccess(clients: tClients, filteredClients: tClients),
      );
      when(() => mockClientsCubit.allClients).thenReturn(tClients);
      when(() => mockClientsCubit.searchClients(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final searchInput = find.byType(ClientSearchBar);
      expect(searchInput, findsOneWidget);

      await tester.enterText(searchInput, 'Stark');
      await tester.pumpAndSettle();

      verify(() => mockClientsCubit.searchClients('Stark')).called(1);
    });

    testWidgets('renders filtered clients list when state contains filteredClients', (
      WidgetTester tester,
    ) async {
      when(() => mockClientsCubit.state).thenReturn(
        ClientsSuccess(clients: tClients, filteredClients: [tClients[1]]),
      );
      when(() => mockClientsCubit.allClients).thenReturn(tClients);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Stark Industries'), findsOneWidget);
      expect(find.text('Acme Corp'), findsNothing);
    });
  });
}
