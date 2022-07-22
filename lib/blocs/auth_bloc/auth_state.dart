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

class AuthBannedState extends AuthState {
  const AuthBannedState();
}

class EmailNotVerifiedState extends AuthState {
  const EmailNotVerifiedState();
}

class ProfileNotExistsState extends AuthState {
  const ProfileNotExistsState();
}