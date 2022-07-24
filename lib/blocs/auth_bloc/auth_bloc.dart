import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  late StreamSubscription<User?> subscription;
  AuthBloc({required this.authService}) : super(const AuthInitial()) {

    on<AuthInitializeEvent>((event, emit) async {
      subscription = authService.getUserStateStream().listen((event) {

        print("EVENT RELOAD");
        if (event != null) {
          event.getIdToken(true);
          print("USER RELOAD");
          if (event.emailVerified) {
            add(EmitSignedInEvent());
          } else {
            add(EmitEmailNotVerifiedEvent());
          }
        } else {
          add(EmitSignedOutEvent());
        }
      });
    });

    on<EmitSignedInEvent>((event, emit) async {
      if (state is !AuthSignedInState) {
        print("TOKEN RELOAD");
        emit(const AuthSignedInState());
      }
    });

    on<EmitSignedOutEvent>((event, emit) {
      if (state is !AuthSignedOutState) {
        emit(const AuthSignedOutState());
      }
    });

    on<EmitEmailNotVerifiedEvent>((event, emit) {
      if (state is !EmailNotVerifiedState) {
        emit(const EmailNotVerifiedState());
      }
    });

    on<EmitSigningUpEvent>((event, emit) {
      if (state is !AuthSigningUpState) {
        emit(const AuthSigningUpState());
      }
    });
  }
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
