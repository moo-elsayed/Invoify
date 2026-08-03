import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_state.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetInvoicesUseCase extends Mock implements GetInvoicesUseCase {}

class MockGetClientsUseCase extends Mock implements GetClientsUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockGetInvoicesUseCase mockGetInvoicesUseCase;
  late MockGetClientsUseCase mockGetClientsUseCase;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  const tUid = 'u1';
  final tNow = DateTime.now();

  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: tUid,
    name: 'Client One',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tNow,
  );

  final tPaidInvoice = InvoiceEntity(
    invoiceId: 'inv_1',
    userId: tUid,
    invoiceNumber: 'INV-001',
    client: tClientEntity,
    issueDate: tNow,
    dueDate: tNow,
    items: [],
    subtotal: 100.0,
    taxRate: 14.0,
    taxAmount: 14.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 114.0,
    status: InvoiceStatus.paid,
    notes: '',
    createdAt: tNow,
    paidAt: tNow,
  );

  final tOverdueInvoice = InvoiceEntity(
    invoiceId: 'inv_2',
    userId: tUid,
    invoiceNumber: 'INV-002',
    client: tClientEntity,
    issueDate: tNow,
    dueDate: tNow,
    items: [],
    subtotal: 50.0,
    taxRate: 0.0,
    taxAmount: 0.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 50.0,
    status: InvoiceStatus.overdue,
    notes: '',
    createdAt: tNow,
  );

  final tSentInvoice = InvoiceEntity(
    invoiceId: 'inv_3',
    userId: tUid,
    invoiceNumber: 'INV-003',
    client: tClientEntity,
    issueDate: tNow,
    dueDate: tNow,
    items: [],
    subtotal: 70.0,
    taxRate: 0.0,
    taxAmount: 0.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 70.0,
    status: InvoiceStatus.sent,
    notes: '',
    createdAt: tNow,
  );

  const tFailure = ServerFailure(error: 'Failed to load data');

  setUp(() {
    mockGetInvoicesUseCase = MockGetInvoicesUseCase();
    mockGetClientsUseCase = MockGetClientsUseCase();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(tUid);
  });

  DashboardCubit sut({FirebaseAuth? auth}) => DashboardCubit(
    mockGetInvoicesUseCase,
    mockGetClientsUseCase,
    firebaseAuth: auth ?? mockFirebaseAuth,
  );

  group('DashboardCubit', () {
    test('initial state should be DashboardInitial', () {
      expect(sut().state, isA<DashboardInitial>());
    });

    group('loadDashboardData', () {
      blocTest<DashboardCubit, DashboardState>(
        'emits nothing when currentUser is null',
        build: () {
          final mockAuthNull = MockFirebaseAuth();
          when(() => mockAuthNull.currentUser).thenReturn(null);
          return sut(auth: mockAuthNull);
        },
        act: (cubit) => cubit.loadDashboardData(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetInvoicesUseCase(any()));
          verifyNever(() => mockGetClientsUseCase(any()));
        },
      );

      blocTest<DashboardCubit, DashboardState>(
        'emits [DashboardLoading, DashboardSuccess] when invoices and clients load successfully',
        build: () {
          when(() => mockGetInvoicesUseCase(tUid)).thenAnswer(
            (_) async =>
                NetworkSuccess([tPaidInvoice, tOverdueInvoice, tSentInvoice]),
          );
          when(
            () => mockGetClientsUseCase(tUid),
          ).thenAnswer((_) async => NetworkSuccess([tClientEntity]));
          return sut();
        },
        act: (cubit) => cubit.loadDashboardData(),
        expect: () => [
          const DashboardLoading(),
          isA<DashboardSuccess>()
              .having(
                (s) => s.monthlyEarnings,
                'monthlyEarnings',
                equals(114.0),
              )
              .having((s) => s.totalOverdue, 'totalOverdue', equals(50.0))
              .having((s) => s.pendingAmount, 'pendingAmount', equals(70.0))
              .having(
                (s) => s.totalClientsCount,
                'totalClientsCount',
                equals(1),
              )
              .having(
                (s) => s.recentInvoices.length,
                'recentInvoices count',
                equals(3),
              ),
        ],
        verify: (_) {
          verify(() => mockGetInvoicesUseCase(tUid)).called(1);
          verify(() => mockGetClientsUseCase(tUid)).called(1);
        },
      );

      blocTest<DashboardCubit, DashboardState>(
        'emits [DashboardLoading, DashboardFailure] when getInvoices fails',
        build: () {
          when(
            () => mockGetInvoicesUseCase(tUid),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          when(
            () => mockGetClientsUseCase(tUid),
          ).thenAnswer((_) async => NetworkSuccess([tClientEntity]));
          return sut();
        },
        act: (cubit) => cubit.loadDashboardData(),
        expect: () => [
          const DashboardLoading(),
          const DashboardFailure('Failed to load data'),
        ],
      );

      blocTest<DashboardCubit, DashboardState>(
        'emits [DashboardLoading, DashboardFailure] when getClients fails',
        build: () {
          when(
            () => mockGetInvoicesUseCase(tUid),
          ).thenAnswer((_) async => NetworkSuccess([tPaidInvoice]));
          when(
            () => mockGetClientsUseCase(tUid),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.loadDashboardData(),
        expect: () => [
          const DashboardLoading(),
          const DashboardFailure('Failed to load data'),
        ],
      );

      blocTest<DashboardCubit, DashboardState>(
        'does not reload data if already in DashboardSuccess and forceRefresh is false',
        seed: () => const DashboardSuccess(
          monthlyEarnings: 100,
          totalOverdue: 0,
          pendingAmount: 0,
          totalClientsCount: 1,
          monthlyRevenueMap: {},
          statusDistribution: {},
          recentInvoices: [],
        ),
        build: () => sut(),
        act: (cubit) => cubit.loadDashboardData(forceRefresh: false),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetInvoicesUseCase(any()));
          verifyNever(() => mockGetClientsUseCase(any()));
        },
      );
    });

    group('updateFromInvoices', () {
      blocTest<DashboardCubit, DashboardState>(
        'updates dashboard success state with new invoices list',
        build: () => sut(),
        act: (cubit) => cubit.updateFromInvoices([tPaidInvoice]),
        expect: () => [
          isA<DashboardSuccess>().having(
            (s) => s.monthlyEarnings,
            'monthlyEarnings',
            equals(114.0),
          ),
        ],
      );
    });

    group('updateClientsCount', () {
      blocTest<DashboardCubit, DashboardState>(
        'updates dashboard success state with new clients count',
        build: () => sut(),
        act: (cubit) => cubit.updateClientsCount(5),
        expect: () => [
          isA<DashboardSuccess>().having(
            (s) => s.totalClientsCount,
            'totalClientsCount',
            equals(5),
          ),
        ],
      );
    });
  });
}
