import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/widgets/client_card.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('ClientCard Widget Tests', () {
    const tClient = ClientEntity(
      clientId: 'c100',
      name: 'Bruce Wayne',
      email: 'bruce@wayne.com',
      phone: '+123456789',
      address: 'Gotham City',
    );

    testWidgets('renders client information (name, email, phone, address)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: ClientCard(client: tClient, onEdit: () {}, onDelete: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bruce Wayne'), findsOneWidget);
      expect(find.text('bruce@wayne.com'), findsOneWidget);
      expect(find.text('+123456789'), findsOneWidget);
      expect(find.text('Gotham City'), findsOneWidget);
    });

    testWidgets('triggers onEdit callback when edit icon button is tapped', (
      WidgetTester tester,
    ) async {
      bool editTapped = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: ClientCard(
            client: tClient,
            onEdit: () => editTapped = true,
            onDelete: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(editTapped, isTrue);
    });

    testWidgets('shows confirmation dialog when delete icon is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: ClientCard(client: tClient, onEdit: () {}, onDelete: () {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(CustomConfirmationDialog), findsOneWidget);
      expect(find.text(AppStrings.deleteClientConfirmation), findsOneWidget);
    });

    testWidgets(
      'triggers onDelete callback when confirm delete is pressed in dialog',
      (WidgetTester tester) async {
        bool deleteConfirmed = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: ClientCard(
              client: tClient,
              onEdit: () {},
              onDelete: () => deleteConfirmed = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete_outline_rounded));
        await tester.pumpAndSettle();

        final confirmBtn = find.text(AppStrings.deleteClient).last;
        await tester.tap(confirmBtn);
        await tester.pumpAndSettle();

        expect(deleteConfirmed, isTrue);
      },
    );
  });
}
