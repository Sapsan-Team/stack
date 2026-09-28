import 'package:either_dart/either.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> getUser(String phoneNumber, String password);
}

