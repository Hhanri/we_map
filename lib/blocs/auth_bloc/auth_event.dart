part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthInitializeEvent extends AuthEvent {}

class EmitSignedInEvent extends AuthEvent {}

class EmitSignedOutEvent extends AuthEvent {}

class EmitBannedEvent extends AuthEvent {}

class EmitEmailNotVerifiedEvent extends AuthEvent {}

class EmitProfileNotExistsEvent extends AuthEvent {}