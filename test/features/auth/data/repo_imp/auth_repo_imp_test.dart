import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:invoify/features/auth/data/models/user_model.dart';
import 'package:invoify/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepoImp sut;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    sut = AuthRepoImp(mockRemoteDataSource);
  });

  final tUserModel = UserModel(
    uid: '123',
    businessName: 'Test Business',
    email: 'test@example.com',
    currency: 'USD',
    createdAt: DateTime(2026, 1, 1),
    isVerified: true,
  );

  final tUserEntity = tUserModel.toUserEntity();
  const tFailure = ServerFailure(error: 'Server Error');

  group('createUserWithEmailAndPassword', () {
    test(
      'should return NetworkSuccess<UserEntity> when remote call succeeds',
      () async {
        when(
          () => mockRemoteDataSource.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
            username: 'Test Business',
          ),
        ).thenAnswer((_) async => NetworkSuccess(tUserModel));

        final result = await sut.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
          username: 'Test Business',
        );

        expect(result, isA<NetworkSuccess<UserEntity>>());
        expect(
          (result as NetworkSuccess<UserEntity>).data,
          equals(tUserEntity),
        );
        verify(
          () => mockRemoteDataSource.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
            username: 'Test Business',
          ),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<UserEntity> when remote call fails',
      () async {
        when(
          () => mockRemoteDataSource.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
            username: 'Test Business',
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
          username: 'Test Business',
        );

        expect(result, isA<NetworkFailure<UserEntity>>());
        expect(
          (result as NetworkFailure<UserEntity>).failure,
          equals(tFailure),
        );
        verify(
          () => mockRemoteDataSource.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
            username: 'Test Business',
          ),
        ).called(1);
      },
    );
  });

  group('signInWithEmailAndPassword', () {
    test(
      'should return NetworkSuccess<UserEntity> when sign in succeeds',
      () async {
        when(
          () => mockRemoteDataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => NetworkSuccess(tUserModel));

        final result = await sut.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        );

        expect(result, isA<NetworkSuccess<UserEntity>>());
        expect(
          (result as NetworkSuccess<UserEntity>).data,
          equals(tUserEntity),
        );
        verify(
          () => mockRemoteDataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<UserEntity> when sign in fails',
      () async {
        when(
          () => mockRemoteDataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        );

        expect(result, isA<NetworkFailure<UserEntity>>());
        expect(
          (result as NetworkFailure<UserEntity>).failure,
          equals(tFailure),
        );
        verify(
          () => mockRemoteDataSource.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          ),
        ).called(1);
      },
    );
  });

  group('googleSignIn', () {
    test(
      'should return NetworkSuccess<UserEntity> when google sign in succeeds',
      () async {
        when(
          () => mockRemoteDataSource.googleSignIn(),
        ).thenAnswer((_) async => NetworkSuccess(tUserModel));

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkSuccess<UserEntity>>());
        expect(
          (result as NetworkSuccess<UserEntity>).data,
          equals(tUserEntity),
        );
        verify(() => mockRemoteDataSource.googleSignIn()).called(1);
      },
    );

    test(
      'should return NetworkFailure<UserEntity> when google sign in fails',
      () async {
        when(
          () => mockRemoteDataSource.googleSignIn(),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkFailure<UserEntity>>());
        expect(
          (result as NetworkFailure<UserEntity>).failure,
          equals(tFailure),
        );
        verify(() => mockRemoteDataSource.googleSignIn()).called(1);
      },
    );
  });

  group('getUserInfo', () {
    test(
      'should return NetworkSuccess<UserEntity> when user info found',
      () async {
        when(
          () => mockRemoteDataSource.getUserInfo('123'),
        ).thenAnswer((_) async => NetworkSuccess(tUserModel));

        final result = await sut.getUserInfo('123');

        expect(result, isA<NetworkSuccess<UserEntity>>());
        expect(
          (result as NetworkSuccess<UserEntity>).data,
          equals(tUserEntity),
        );
        verify(() => mockRemoteDataSource.getUserInfo('123')).called(1);
      },
    );

    test(
      'should return NetworkFailure<UserEntity> when user info fetching fails',
      () async {
        when(
          () => mockRemoteDataSource.getUserInfo('123'),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.getUserInfo('123');

        expect(result, isA<NetworkFailure<UserEntity>>());
        expect(
          (result as NetworkFailure<UserEntity>).failure,
          equals(tFailure),
        );
        verify(() => mockRemoteDataSource.getUserInfo('123')).called(1);
      },
    );
  });

  group('signOut', () {
    test('should return NetworkSuccess<void> when signOut succeeds', () async {
      when(
        () => mockRemoteDataSource.signOut(),
      ).thenAnswer((_) async => const NetworkSuccess<void>());

      final result = await sut.signOut();

      expect(result, isA<NetworkSuccess<void>>());
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });

    test('should return NetworkFailure<void> when signOut fails', () async {
      when(
        () => mockRemoteDataSource.signOut(),
      ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

      final result = await sut.signOut();

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });
  });

  group('forgetPassword', () {
    test(
      'should return NetworkSuccess<void> when reset email is sent',
      () async {
        when(
          () => mockRemoteDataSource.forgetPassword('test@example.com'),
        ).thenAnswer((_) async => const NetworkSuccess<void>());

        final result = await sut.forgetPassword('test@example.com');

        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockRemoteDataSource.forgetPassword('test@example.com'),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<void> when reset email sending fails',
      () async {
        when(
          () => mockRemoteDataSource.forgetPassword('test@example.com'),
        ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

        final result = await sut.forgetPassword('test@example.com');

        expect(result, isA<NetworkFailure<void>>());
        expect((result as NetworkFailure<void>).failure, equals(tFailure));
        verify(
          () => mockRemoteDataSource.forgetPassword('test@example.com'),
        ).called(1);
      },
    );
  });
}
