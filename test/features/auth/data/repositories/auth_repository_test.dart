import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core_ui_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:core_ui_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:core_ui_template/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:core_ui_template/core/errors/failures.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = User(id: '1', name: 'Test User', email: tEmail);

  group('login', () {
    test(
      'should return User when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenAnswer((_) async => tUser);

        // act
        final result = await repository.login(tEmail, tPassword);

        // assert
        expect(result, const Right(tUser));
        verify(() => mockRemoteDataSource.login(tEmail, tPassword));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return ServerFailure when the call to remote data source throws Exception',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenThrow(Exception());

        // act
        final result = await repository.login(tEmail, tPassword);

        // assert
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (user) => fail('Should return a failure'),
        );
        verify(() => mockRemoteDataSource.login(tEmail, tPassword));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
