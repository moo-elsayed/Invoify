import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/use_cases/add_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/delete_client_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/clients/domain/use_cases/update_client_use_case.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetClientsUseCase extends Mock implements GetClientsUseCase {}

class MockAddClientUseCase extends Mock implements AddClientUseCase {}

class MockUpdateClientUseCase extends Mock implements UpdateClientUseCase {}

class MockDeleteClientUseCase extends Mock implements DeleteClientUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockGetClientsUseCase mockGetClientsUseCase;
  late MockAddClientUseCase mockAddClientUseCase;
  late MockUpdateClientUseCase mockUpdateClientUseCase;
  late MockDeleteClientUseCase mockDeleteClientUseCase;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  const tUid = 'u1';

  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: tUid,
    name: 'John Doe',
    email: 'john@example.com',
    phone: '123456',
    address: 'Street 1',
    createdAt: DateTime(2026, 1, 1),
  );

  const tFailure = ServerFailure(error: 'Operation Failed');

  setUpAll(() {
    registerFallbackValue(tClientEntity);
  });

  setUp(() {
    mockGetClientsUseCase = MockGetClientsUseCase();
    mockAddClientUseCase = MockAddClientUseCase();
    mockUpdateClientUseCase = MockUpdateClientUseCase();
    mockDeleteClientUseCase = MockDeleteClientUseCase();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();

    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(tUid);
  });

  ClientsCubit sut({FirebaseAuth? auth}) => ClientsCubit(
    mockGetClientsUseCase,
    mockAddClientUseCase,
    mockUpdateClientUseCase,
    mockDeleteClientUseCase,
    firebaseAuth: auth ?? mockFirebaseAuth,
  );

  group('ClientsCubit', () {
    test('initial state should be ClientsInitial', () {
      expect(sut().state, isA<ClientsInitial>());
    });

    group('getClients', () {
      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientsLoading, ClientsSuccess] when getClients succeeds',
        build: () {
          when(
            () => mockGetClientsUseCase(tUid),
          ).thenAnswer((_) async => NetworkSuccess([tClientEntity]));
          return sut();
        },
        act: (cubit) => cubit.getClients(),
        expect: () => [isA<ClientsLoading>(), isA<ClientsSuccess>()],
        verify: (_) {
          verify(() => mockGetClientsUseCase(tUid)).called(1);
        },
      );

      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientsLoading, ClientsFailure] when getClients fails',
        build: () {
          when(
            () => mockGetClientsUseCase(tUid),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.getClients(),
        expect: () => [isA<ClientsLoading>(), isA<ClientsFailure>()],
        verify: (_) {
          verify(() => mockGetClientsUseCase(tUid)).called(1);
        },
      );

      blocTest<ClientsCubit, ClientsState>(
        'emits nothing when currentUser is null',
        build: () {
          final mockAuthNull = MockFirebaseAuth();
          when(() => mockAuthNull.currentUser).thenReturn(null);
          return sut(auth: mockAuthNull);
        },
        act: (cubit) => cubit.getClients(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetClientsUseCase(any()));
        },
      );
    });

    group('addClient', () {
      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionSuccess, ClientsSuccess] when addClient succeeds',
        build: () {
          when(
            () => mockAddClientUseCase(any()),
          ).thenAnswer((_) async => NetworkSuccess(tClientEntity));
          return sut();
        },
        act: (cubit) => cubit.addClient(
          name: 'John Doe',
          email: 'john@example.com',
          phone: '123456',
          address: 'Street 1',
        ),
        expect: () => [
          isA<ClientActionLoading>(),
          isA<ClientActionSuccess>(),
          isA<ClientsSuccess>(),
        ],
        verify: (_) {
          verify(() => mockAddClientUseCase(any())).called(1);
        },
      );

      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionFailure] when addClient fails',
        build: () {
          when(
            () => mockAddClientUseCase(any()),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut();
        },
        act: (cubit) => cubit.addClient(
          name: 'John Doe',
          email: 'john@example.com',
          phone: '123456',
          address: 'Street 1',
        ),
        expect: () => [isA<ClientActionLoading>(), isA<ClientActionFailure>()],
        verify: (_) {
          verify(() => mockAddClientUseCase(any())).called(1);
        },
      );
    });

    group('updateClient', () {
      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionSuccess, ClientsSuccess] when updateClient succeeds',
        build: () {
          when(
            () => mockUpdateClientUseCase(tClientEntity),
          ).thenAnswer((_) async => const NetworkSuccess<void>());
          return sut();
        },
        act: (cubit) => cubit.updateClient(tClientEntity),
        expect: () => [
          isA<ClientActionLoading>(),
          isA<ClientActionSuccess>(),
          isA<ClientsSuccess>(),
        ],
        verify: (_) {
          verify(() => mockUpdateClientUseCase(tClientEntity)).called(1);
        },
      );

      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionFailure] when updateClient fails',
        build: () {
          when(
            () => mockUpdateClientUseCase(tClientEntity),
          ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
          return sut();
        },
        act: (cubit) => cubit.updateClient(tClientEntity),
        expect: () => [isA<ClientActionLoading>(), isA<ClientActionFailure>()],
        verify: (_) {
          verify(() => mockUpdateClientUseCase(tClientEntity)).called(1);
        },
      );
    });

    group('deleteClient', () {
      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionSuccess, ClientsSuccess] when deleteClient succeeds',
        build: () {
          when(
            () => mockDeleteClientUseCase('c1'),
          ).thenAnswer((_) async => const NetworkSuccess<void>());
          return sut();
        },
        act: (cubit) => cubit.deleteClient('c1'),
        expect: () => [
          isA<ClientActionLoading>(),
          isA<ClientActionSuccess>(),
          isA<ClientsSuccess>(),
        ],
        verify: (_) {
          verify(() => mockDeleteClientUseCase('c1')).called(1);
        },
      );

      blocTest<ClientsCubit, ClientsState>(
        'emits [ClientActionLoading, ClientActionFailure] when deleteClient fails',
        build: () {
          when(
            () => mockDeleteClientUseCase('c1'),
          ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
          return sut();
        },
        act: (cubit) => cubit.deleteClient('c1'),
        expect: () => [isA<ClientActionLoading>(), isA<ClientActionFailure>()],
        verify: (_) {
          verify(() => mockDeleteClientUseCase('c1')).called(1);
        },
      );
    });

    group('searchClients', () {
      blocTest<ClientsCubit, ClientsState>(
        'filters clients based on search query',
        build: () => sut(),
        act: (cubit) => cubit.searchClients('john'),
        expect: () => [isA<ClientsSuccess>()],
      );
    });
  });
}
