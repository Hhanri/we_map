part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  const AuthState({required this.isLoading, this.errorMessage});
}

class AuthInitial extends AuthState {
  const AuthInitial({required super.isLoading, super.errorMessage});

  @override
  List<Object> get props => [];
}

class AuthSignedInState extends AuthState {
  const AuthSignedInState({required super.isLoading, super.errorMessage});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthSignedOutState extends AuthState {
  const AuthSignedOutState({required super.isLoading, super.errorMessage});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthBannedState extends AuthState {
  const AuthBannedState({required super.isLoading, super.errorMessage});

  @override
  List<Object?> get props => throw UnimplementedError();
}