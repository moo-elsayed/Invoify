import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/forget_password_cubit/forget_password_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

void main() {
  late MockForgetPasswordUseCase mockUseCase;

  const tEmail = 'test@example.com';
  const tFailure = ServerFailure(error: 'User not found');

  setUp(() {
    mockUseCase = MockForgetPasswordUseCase();
  });

  group('ForgetPasswordCubit', () {
    test('initial state should be ForgetPasswordInitial', () {
      expect(
        ForgetPasswordCubit(mockUseCase).state,
        isA<ForgetPasswordInitial>(),
      );
    });

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [ForgetPasswordLoading, ForgetPasswordSuccess] when forgetPassword succeeds',
      build: () {
        when(
          () => mockUseCase(tEmail),
        ).thenAnswer((_) async => const NetworkSuccess<void>());
        return ForgetPasswordCubit(mockUseCase);
      },
      act: (cubit) => cubit.forgetPassword(tEmail),
      expect: () => [
        isA<ForgetPasswordLoading>(),
        isA<ForgetPasswordSuccess>(),
      ],
      verify: (_) {
        verify(() => mockUseCase(tEmail)).called(1);
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits [ForgetPasswordLoading, ForgetPasswordFailure] when forgetPassword fails',
      build: () {
        when(
          () => mockUseCase(tEmail),
        ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
        return ForgetPasswordCubit(mockUseCase);
      },
      act: (cubit) => cubit.forgetPassword(tEmail),
      expect: () => [
        isA<ForgetPasswordLoading>(),
        isA<ForgetPasswordFailure>(),
      ],
      verify: (_) {
        verify(() => mockUseCase(tEmail)).called(1);
      },
    );
  });
}
