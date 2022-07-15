import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  AuthBloc({required this.authService}) : super(const AuthInitial()) {

    on<AuthInitializeEvent>((event, emit) async {
      authService.getUserStateStream().listen((event) {
        event?.reload();
        if (event != null) {
          add(EmitSignedInEvent());
        } else {
          add(EmitSignedOutEvent());
        }
      });
    });

    on<EmitBannedEvent>((event, emit) {
      emit(const AuthBannedState());
    });

    on<EmitSignedInEvent>((event, emit) {
      emit(const AuthSignedInState());
    });

    on<EmitSignedOutEvent>((event, emit) {
      emit(const AuthSignedOutState());
    });
  }
}
