import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  late StreamSubscription<bool> subscription;
  AuthBloc({required this.authService}) : super(const AuthInitial()) {

    on<AuthInitializeEvent>((event, emit) async {
      authService.getUserStateStream().listen((event) {
        event?.reload();
        if (event != null) {
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



    on<EmitBannedEvent>((event, emit) {
      emit(const AuthBannedState());
    });

    on<EmitSignedInEvent>((event, emit) {
      emit(const AuthSignedInState());
    });

    on<EmitSignedOutEvent>((event, emit) {
      emit(const AuthSignedOutState());
    });

    on<EmitEmailNotVerifiedEvent>((event, emit) {
      emit(const EmailNotVerifiedState());
    });

    on<EmitProfileNotExistsEvent>((event, emit) {
      emit(const ProfileNotExistsState());
    });
  }
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
