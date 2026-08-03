import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/signout_cubit/sign_out_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockUserInfoCubit extends Mock implements UserInfoCubit {}

void main() {
  late MockSignOutUseCase mockUseCase;
  late MockUserInfoCubit mockUserInfoCubit;

  const tFailure = ServerFailure(error: 'Sign out failed');

  setUp(() {
    mockUseCase = MockSignOutUseCase();
    mockUserInfoCubit = MockUserInfoCubit();

    when(() => mockUserInfoCubit.clearUserLocally()).thenAnswer((_) async {});

    if (GetIt.instance.isRegistered<UserInfoCubit>()) {
      GetIt.instance.unregister<UserInfoCubit>();
    }
    GetIt.instance.registerSingleton<UserInfoCubit>(mockUserInfoCubit);
  });

  group('SignOutCubit', () {
    test('initial state should be SignOutInitial', () {
      expect(SignOutCubit(mockUseCase).state, isA<SignOutInitial>());
    });

    blocTest<SignOutCubit, SignOutState>(
      'emits [SignOutLoading, SignOutSuccess] and clears user locally when signOut succeeds',
      build: () {
        when(
          () => mockUseCase(),
        ).thenAnswer((_) async => const NetworkSuccess<void>());
        return SignOutCubit(mockUseCase);
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [isA<SignOutLoading>(), isA<SignOutSuccess>()],
      verify: (_) {
        verify(() => mockUserInfoCubit.clearUserLocally()).called(1);
      },
    );

    blocTest<SignOutCubit, SignOutState>(
      'emits [SignOutLoading, SignOutFailure] when signOut fails',
      build: () {
        when(
          () => mockUseCase(),
        ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
        return SignOutCubit(mockUseCase);
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [isA<SignOutLoading>(), isA<SignOutFailure>()],
    );
  });
}
