import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:invoify/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  late MockSettingsRemoteDataSource mockDataSource;
  late SettingsRepoImp sut;

  setUp(() {
    mockDataSource = MockSettingsRemoteDataSource();
    sut = SettingsRepoImp(mockDataSource);
  });

  const tUid = 'u1';
  const tFailure = ServerFailure(error: 'Database Error');

  group('updateCurrency', () {
    test(
      'should forward updateCurrency to remote data source and return NetworkSuccess<void>',
      () async {
        when(
          () => mockDataSource.updateCurrency(uid: tUid, currency: 'EUR'),
        ).thenAnswer((_) async => const NetworkSuccess());

        final result = await sut.updateCurrency(uid: tUid, currency: 'EUR');

        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockDataSource.updateCurrency(uid: tUid, currency: 'EUR'),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<void> when remote data source fails on updateCurrency',
      () async {
        when(
          () => mockDataSource.updateCurrency(uid: tUid, currency: 'EUR'),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.updateCurrency(uid: tUid, currency: 'EUR');

        expect(result, isA<NetworkFailure<void>>());
        expect((result as NetworkFailure<void>).failure, equals(tFailure));
        verify(
          () => mockDataSource.updateCurrency(uid: tUid, currency: 'EUR'),
        ).called(1);
      },
    );
  });

  group('updateBusinessName', () {
    test(
      'should forward updateBusinessName to remote data source and return NetworkSuccess<void>',
      () async {
        when(
          () => mockDataSource.updateBusinessName(
            uid: tUid,
            businessName: 'Corp',
          ),
        ).thenAnswer((_) async => const NetworkSuccess());

        final result = await sut.updateBusinessName(
          uid: tUid,
          businessName: 'Corp',
        );

        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockDataSource.updateBusinessName(
            uid: tUid,
            businessName: 'Corp',
          ),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<void> when remote data source fails on updateBusinessName',
      () async {
        when(
          () => mockDataSource.updateBusinessName(
            uid: tUid,
            businessName: 'Corp',
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.updateBusinessName(
          uid: tUid,
          businessName: 'Corp',
        );

        expect(result, isA<NetworkFailure<void>>());
        expect((result as NetworkFailure<void>).failure, equals(tFailure));
        verify(
          () => mockDataSource.updateBusinessName(
            uid: tUid,
            businessName: 'Corp',
          ),
        ).called(1);
      },
    );
  });
}
