import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class RegistrationFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ConnectFailure extends Failure {
  @override
  List<Object?> get props => [];
}