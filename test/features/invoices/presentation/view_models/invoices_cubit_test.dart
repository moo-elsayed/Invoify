import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/use_cases/create_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_stream_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetInvoicesStreamUseCase extends Mock
    implements GetInvoicesStreamUseCase {}

class MockCreateInvoiceUseCase extends Mock implements CreateInvoiceUseCase {}

class MockUpdateInvoiceUseCase extends Mock implements UpdateInvoiceUseCase {}

class MockDeleteInvoiceUseCase extends Mock implements DeleteInvoiceUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockGetInvoicesStreamUseCase mockGetInvoicesStreamUseCase;
  late MockCreateInvoiceUseCase mockCreateInvoiceUseCase;
  late MockUpdateInvoiceUseCase mockUpdateInvoiceUseCase;
  late MockDeleteInvoiceUseCase mockDeleteInvoiceUseCase;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  const tUid = 'u1';
  final tDate = DateTime(2026, 1, 1);

  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: tUid,
    name: 'Client Name',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate,
  );

  final tInvoiceEntity = InvoiceEntity(
    invoiceId: 'inv_1',
    userId: tUid,
    invoiceNumber: 'INV-001',
    client: tClientEntity,
    issueDate: tDate,
    dueDate: tDate,
    items: [],
    subtotal: 100.0,
    taxRate: 14.0,
    taxAmount: 14.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 114.0,
    status: InvoiceStatus.draft,
    notes: '',
    createdAt: tDate,
  );

  final tSentInvoiceEntity = tInvoiceEntity.copyWith(
    status: InvoiceStatus.sent,
  );

  const tFailure = ServerFailure(error: 'Action Failed');

  setUpAll(() {
    registerFallbackValue(tInvoiceEntity);
  });

  setUp(() {
    mockGetInvoicesStreamUseCase = MockGetInvoicesStreamUseCase();
    mockCreateInvoiceUseCase = MockCreateInvoiceUseCase();
    mockUpdateInvoiceUseCase = MockUpdateInvoiceUseCase();
    mockDeleteInvoiceUseCase = MockDeleteInvoiceUseCase();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(tUid);
  });

  InvoicesCubit sut({FirebaseAuth? auth}) => InvoicesCubit(
    mockGetInvoicesStreamUseCase,
    mockCreateInvoiceUseCase,
    mockUpdateInvoiceUseCase,
    mockDeleteInvoiceUseCase,
    firebaseAuth: auth ?? mockFirebaseAuth,
  );

  group('InvoicesCubit', () {
    test('initial state should be InvoicesInitial', () {
      expect(sut().state, isA<InvoicesInitial>());
    });

    group('getInvoices', () {
      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesLoading, InvoicesSuccess] when stream emits invoices list',
        build: () {
          when(
            () => mockGetInvoicesStreamUseCase(tUid),
          ).thenAnswer((_) => Stream.value([tInvoiceEntity]));
          return sut();
        },
        act: (cubit) => cubit.getInvoices(),
        expect: () => [
          const InvoicesLoading(),
          InvoicesSuccess([tInvoiceEntity]),
        ],
        verify: (_) {
          verify(() => mockGetInvoicesStreamUseCase(tUid)).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesLoading, InvoicesFailure] when stream emits error',
        build: () {
          when(
            () => mockGetInvoicesStreamUseCase(tUid),
          ).thenAnswer((_) => Stream.error('Stream error'));
          return sut();
        },
        act: (cubit) => cubit.getInvoices(),
        expect: () => [
          const InvoicesLoading(),
          const InvoicesFailure('Stream error'),
        ],
        verify: (_) {
          verify(() => mockGetInvoicesStreamUseCase(tUid)).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits nothing when currentUser is null',
        build: () {
          final mockAuthNull = MockFirebaseAuth();
          when(() => mockAuthNull.currentUser).thenReturn(null);
          return sut(auth: mockAuthNull);
        },
        act: (cubit) => cubit.getInvoices(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetInvoicesStreamUseCase(any()));
        },
      );
    });

    group('createInvoice', () {
      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoiceActionSuccess] when createInvoice succeeds',
        build: () {
          when(
            () => mockCreateInvoiceUseCase(any()),
          ).thenAnswer((_) async => NetworkSuccess(tInvoiceEntity));
          return sut();
        },
        act: (cubit) => cubit.createInvoice(tInvoiceEntity),
        expect: () => [
          InvoiceActionSuccess(AppStrings.invoiceCreatedSuccessfully),
        ],
        verify: (_) {
          verify(() => mockCreateInvoiceUseCase(any())).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesFailure] when createInvoice fails',
        build: () {
          when(
            () => mockCreateInvoiceUseCase(any()),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.createInvoice(tInvoiceEntity),
        expect: () => [const InvoicesFailure('Action Failed')],
        verify: (_) {
          verify(() => mockCreateInvoiceUseCase(any())).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits nothing when currentUser is null on createInvoice',
        build: () {
          final mockAuthNull = MockFirebaseAuth();
          when(() => mockAuthNull.currentUser).thenReturn(null);
          return sut(auth: mockAuthNull);
        },
        act: (cubit) => cubit.createInvoice(tInvoiceEntity),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockCreateInvoiceUseCase(any()));
        },
      );
    });

    group('updateInvoice', () {
      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoiceActionSuccess] with invoiceUpdatedSuccessfully when status is not sent',
        build: () {
          when(
            () => mockUpdateInvoiceUseCase(tInvoiceEntity),
          ).thenAnswer((_) async => const NetworkSuccess());
          return sut();
        },
        act: (cubit) => cubit.updateInvoice(tInvoiceEntity),
        expect: () => [
          InvoiceActionSuccess(AppStrings.invoiceUpdatedSuccessfully),
        ],
        verify: (_) {
          verify(() => mockUpdateInvoiceUseCase(tInvoiceEntity)).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoiceActionSuccess] with invoiceSentSuccessfully when status is sent',
        build: () {
          when(
            () => mockUpdateInvoiceUseCase(tSentInvoiceEntity),
          ).thenAnswer((_) async => const NetworkSuccess());
          return sut();
        },
        act: (cubit) => cubit.updateInvoice(tSentInvoiceEntity),
        expect: () => [
          InvoiceActionSuccess(AppStrings.invoiceSentSuccessfully),
        ],
        verify: (_) {
          verify(() => mockUpdateInvoiceUseCase(tSentInvoiceEntity)).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesFailure] when updateInvoice fails',
        build: () {
          when(
            () => mockUpdateInvoiceUseCase(tInvoiceEntity),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.updateInvoice(tInvoiceEntity),
        expect: () => [const InvoicesFailure('Action Failed')],
        verify: (_) {
          verify(() => mockUpdateInvoiceUseCase(tInvoiceEntity)).called(1);
        },
      );
    });

    group('deleteInvoice', () {
      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesSuccess] when deleteInvoice succeeds',
        build: () {
          when(
            () => mockDeleteInvoiceUseCase('inv_1'),
          ).thenAnswer((_) async => const NetworkSuccess());
          return sut();
        },
        act: (cubit) => cubit.deleteInvoice('inv_1'),
        expect: () => [const InvoicesSuccess([])],
        verify: (_) {
          verify(() => mockDeleteInvoiceUseCase('inv_1')).called(1);
        },
      );

      blocTest<InvoicesCubit, InvoicesState>(
        'emits [InvoicesFailure] when deleteInvoice fails',
        build: () {
          when(
            () => mockDeleteInvoiceUseCase('inv_1'),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.deleteInvoice('inv_1'),
        expect: () => [const InvoicesFailure('Action Failed')],
        verify: (_) {
          verify(() => mockDeleteInvoiceUseCase('inv_1')).called(1);
        },
      );
    });

    group('refreshLocalInvoices', () {
      blocTest<InvoicesCubit, InvoicesState>(
        'emits InvoicesSuccess with current local invoices list',
        build: () => sut(),
        act: (cubit) => cubit.refreshLocalInvoices(),
        expect: () => [const InvoicesSuccess([])],
      );
    });
  });
}
