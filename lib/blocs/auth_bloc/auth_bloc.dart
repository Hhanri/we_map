import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  AuthBloc({required this.authService}) : super(const AuthInitial(isLoading: true)) {

    on<AuthInitializeEvent>((event, emit) async {
      authService.getUserStateStream().listen((event) {
        if (event != null) {
          emit(const AuthSignedInState(isLoading: false));
        } else {
          emit(const AuthSignedOutState(isLoading: false));
        }
      });
      if (authService.isSignedIn) {
        authService.getUserBanStateStream().listen((isBanned) {
          if (isBanned) {
            emit(const AuthSignedInState(isLoading: false));
          }
        });
      }
    });
  }
}
