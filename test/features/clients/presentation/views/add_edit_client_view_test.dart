import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/clients/presentation/views/add_edit_client_view.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockClientsCubit extends MockCubit<ClientsState>
    implements ClientsCubit {}

class FakeClientEntity extends Fake implements ClientEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeClientEntity());
  });

  late MockClientsCubit mockClientsCubit;

  const tExistingClient = ClientEntity(
    clientId: 'c101',
    name: 'Clark Kent',
    email: 'clark@dailyplanet.com',
    phone: '+999888',
    address: 'Metropolis',
  );

  setUp(() {
    mockClientsCubit = MockClientsCubit();
    when(() => mockClientsCubit.state).thenReturn(ClientsInitial());
  });

  Widget buildTestableWidget({ClientEntity? client}) => createWidgetForTesting(
    child: BlocProvider<ClientsCubit>.value(
      value: mockClientsCubit,
      child: AddEditClientView(client: client),
    ),
  );

  group('AddEditClientView Widget Tests', () {
    testWidgets('renders empty form inputs in Add Mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(
        find.text(AppStrings.addClient),
        findsNWidgets(2),
      ); // AppBar title & Save button
      expect(find.byType(TextFormFieldHelper), findsNWidgets(4));
    });

    testWidgets('pre-fills existing client data in Edit Mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(client: tExistingClient));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.editClient), findsOneWidget);
      expect(find.text('Clark Kent'), findsOneWidget);
      expect(find.text('clark@dailyplanet.com'), findsOneWidget);
      expect(find.text('+999888'), findsOneWidget);
      expect(find.text('Metropolis'), findsOneWidget);
    });

    testWidgets(
      'calls addClient on cubit when submitting valid new client form',
      (WidgetTester tester) async {
        when(() => mockClientsCubit.addClient(any())).thenAnswer((_) async {});

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'Lex Luthor');
        await tester.enterText(fields.at(1), 'lex@corp.com');
        await tester.enterText(fields.at(2), '+112233');
        await tester.enterText(fields.at(3), 'LexCorp Tower');
        await tester.pumpAndSettle();

        final saveBtn = find
            .widgetWithText(CustomMaterialButton, AppStrings.addClient)
            .last;
        await tester.tap(saveBtn);
        await tester.pump();

        verify(() => mockClientsCubit.addClient(any())).called(1);
      },
    );

    testWidgets(
      'calls updateClient on cubit when submitting updated client form in Edit Mode',
      (WidgetTester tester) async {
        when(
          () => mockClientsCubit.updateClient(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(buildTestableWidget(client: tExistingClient));
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'Clark Kent Updated');
        await tester.pumpAndSettle();

        final saveBtn = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.saveChanges,
        );
        await tester.tap(saveBtn);
        await tester.pump();

        verify(() => mockClientsCubit.updateClient(any())).called(1);
      },
    );
  });
}
