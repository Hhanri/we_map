part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSignedInState extends AuthState {
  const AuthSignedInState();
}

class AuthSignedOutState extends AuthState {
  const AuthSignedOutState();
}

class EmailNotVerifiedState extends AuthState {
  const EmailNotVerifiedState();
}

class AuthSigningUpState extends AuthState {
  const AuthSigningUpState();
}