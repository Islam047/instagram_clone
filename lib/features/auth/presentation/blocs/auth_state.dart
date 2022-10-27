part of 'auth_bloc.dart';

enum AuthOverviewStatus { initial, loading, success, failure,following,signOut }

class AuthOverviewState extends Equatable {
  const AuthOverviewState({
    this.status = AuthOverviewStatus.initial,
    this.users = const [],
    this.user,
    this.error,
  });

  final AuthOverviewStatus status;
  final String? error;
  final User? user;
  final List<User>? users;

  AuthOverviewState copyWith({
    AuthOverviewStatus Function()? status,
    List<User> Function()? users,
    User Function()? user,
    String? Function()? error,
  }) {
    return AuthOverviewState(
      status: status != null ? status() : this.status,
      users: users != null ? users() : this.users,
      user: user != null ? user() : this.user,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, users, user, error];
}
