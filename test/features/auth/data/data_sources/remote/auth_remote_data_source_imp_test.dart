import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:invoify/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  late AuthRemoteDataSourceImp sut;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(FakeAuthProvider());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    sut = AuthRemoteDataSourceImp(
      firebaseAuth: mockFirebaseAuth,
      firestore: fakeFirestore,
    );
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  group('createUserWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUsername = 'Test Business';
    const tUid = 'uid_123';

    test(
      'should create user in Auth and save user profile in fake Firestore',
      () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUid);
        when(() => mockUser.emailVerified).thenReturn(false);
        when(
          () => mockUser.updateDisplayName(tUsername),
        ).thenAnswer((_) async {});
        when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        final result = await sut.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        expect(result, isA<NetworkSuccess<UserModel>>());
        final userModel = (result as NetworkSuccess<UserModel>).data;
        expect(userModel?.uid, equals(tUid));
        expect(userModel?.email, equals(tEmail));
        expect(userModel?.businessName, equals(tUsername));

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.exists, isTrue);
        expect(snapshot.data()?['email'], equals(tEmail));
        expect(snapshot.data()?['businessName'], equals(tUsername));
      },
    );

    test('should return NetworkFailure when user returned is null', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(null);

      final result = await sut.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      );

      expect(result, isA<NetworkFailure<UserModel>>());
    });

    test(
      'should NOT delete currentUser when FirebaseAuthException code is email-already-in-use',
      () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final result = await sut.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        expect(result, isA<NetworkFailure<UserModel>>());
        verifyNever(() => mockUser.delete());
      },
    );

    test(
      'should delete currentUser when FirebaseAuthException is weak-password',
      () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'weak-password'));
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.delete()).thenAnswer((_) async {});

        final result = await sut.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        expect(result, isA<NetworkFailure<UserModel>>());
        verify(() => mockUser.delete()).called(1);
      },
    );

    test(
      'should delete currentUser when an unexpected Exception occurs',
      () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(Exception('Firestore write failed'));
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.delete()).thenAnswer((_) async {});

        final result = await sut.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        expect(result, isA<NetworkFailure<UserModel>>());
        verify(() => mockUser.delete()).called(1);
      },
    );
  });

  group('signInWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUid = 'uid_123';

    test('should return NetworkFailure when user returned is null', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(null);

      final result = await sut.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, isA<NetworkFailure<UserModel>>());
    });

    test(
      'should return NetworkFailure and sign out if email is not verified',
      () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.reload()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<NetworkFailure<UserModel>>());
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should return NetworkSuccess and update isVerified in fake Firestore when verified',
      () async {
        await fakeFirestore.collection('users').doc(tUid).set({
          'uid': tUid,
          'businessName': 'Existing Corp',
          'email': tEmail,
          'currency': 'USD',
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': false,
        });

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.reload()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.uid).thenReturn(tUid);

        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<NetworkSuccess<UserModel>>());
        expect((result as NetworkSuccess<UserModel>).data?.uid, equals(tUid));

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.data()?['isVerified'], isTrue);
      },
    );

    test(
      'should return NetworkSuccess and create user doc if verified but not in DB',
      () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.reload()).thenAnswer((_) async {});
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(true);
        when(() => mockUser.uid).thenReturn(tUid);
        when(() => mockUser.displayName).thenReturn('New Verified User');
        when(() => mockUser.email).thenReturn(tEmail);

        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<NetworkSuccess<UserModel>>());

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.exists, isTrue);
      },
    );

    test(
      'should return NetworkFailure when FirebaseAuthException is thrown (e.g. wrong-password)',
      () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<NetworkFailure<UserModel>>());
      },
    );
  });

  group('googleSignIn', () {
    const tUid = 'uid_google';
    const tEmail = 'google@example.com';

    test(
      'should return NetworkSuccess and sync user with fake Firestore',
      () async {
        when(
          () => mockFirebaseAuth.signInWithProvider(any()),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUid);
        when(() => mockUser.email).thenReturn(tEmail);
        when(() => mockUser.displayName).thenReturn('Google User');
        when(() => mockUser.emailVerified).thenReturn(true);

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkSuccess<UserModel>>());
        expect(
          (result as NetworkSuccess<UserModel>).data?.email,
          equals(tEmail),
        );

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.exists, isTrue);
      },
    );

    test(
      'should return NetworkFailure when google sign in user is null',
      () async {
        when(
          () => mockFirebaseAuth.signInWithProvider(any()),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkFailure<UserModel>>());
        expect(
          (result as NetworkFailure<UserModel>).failure.error,
          equals(AppStrings.unexpectedError),
        );
      },
    );

    test(
      'should return NetworkFailure with googleSignInCancelled error when FirebaseAuthException is web-context-canceled',
      () async {
        when(
          () => mockFirebaseAuth.signInWithProvider(any()),
        ).thenThrow(FirebaseAuthException(code: 'web-context-canceled'));

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkFailure<UserModel>>());
        expect(
          (result as NetworkFailure<UserModel>).failure.error,
          equals(AppStrings.googleSignInCancelled),
        );
      },
    );

    test(
      'should return NetworkFailure when FirebaseAuthException occurs during Google Sign In',
      () async {
        when(() => mockFirebaseAuth.signInWithProvider(any())).thenThrow(
          FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          ),
        );

        final result = await sut.googleSignIn();

        expect(result, isA<NetworkFailure<UserModel>>());
      },
    );
  });

  group('forgetPassword', () {
    const tEmail = 'reset@example.com';

    test(
      'should return NetworkFailure if user email does not exist in Firestore',
      () async {
        final result = await sut.forgetPassword(tEmail);

        expect(result, isA<NetworkFailure<void>>());
      },
    );

    test(
      'should send reset email when user email exists in fake Firestore',
      () async {
        await fakeFirestore.collection('users').doc('user_reset').set({
          'email': tEmail,
          'businessName': 'Reset Corp',
        });

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).thenAnswer((_) async {});

        final result = await sut.forgetPassword(tEmail);

        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure when FirebaseAuthException is thrown while sending reset email',
      () async {
        await fakeFirestore.collection('users').doc('user_reset').set({
          'email': tEmail,
          'businessName': 'Reset Corp',
        });

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        final result = await sut.forgetPassword(tEmail);

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });

  group('getUserInfo', () {
    const tUid = 'uid_info';

    test(
      'should return user model when document exists in fake Firestore',
      () async {
        await fakeFirestore.collection('users').doc(tUid).set({
          'uid': tUid,
          'businessName': 'Info Corp',
          'email': 'info@example.com',
          'currency': 'EUR',
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': true,
        });

        final result = await sut.getUserInfo(tUid);

        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user?.uid, equals(tUid));
        expect(user?.currency, equals('EUR'));
      },
    );

    test(
      'should return verified user when firestoreVerified is false but authVerified is true',
      () async {
        await fakeFirestore.collection('users').doc(tUid).set({
          'uid': tUid,
          'businessName': 'Info Corp',
          'email': 'info@example.com',
          'currency': 'USD',
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': false,
        });

        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.emailVerified).thenReturn(true);

        final result = await sut.getUserInfo(tUid);

        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user?.isVerified, isTrue);
      },
    );

    test(
      'should return NetworkFailure when document does not exist in fake Firestore',
      () async {
        final result = await sut.getUserInfo(tUid);

        expect(result, isA<NetworkFailure<UserModel>>());
      },
    );
  });

  group('signOut', () {
    test(
      'should call signOut on FirebaseAuth and return NetworkSuccess',
      () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        final result = await sut.signOut();

        expect(result, isA<NetworkSuccess<void>>());
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should return NetworkFailure when FirebaseAuth throws an exception during signOut',
      () async {
        when(
          () => mockFirebaseAuth.signOut(),
        ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        final result = await sut.signOut();

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });
}
