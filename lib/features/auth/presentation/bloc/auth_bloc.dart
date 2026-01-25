import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/get_session.dart';
import '../../domain/usecases/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetSession getSession,
    required SignOut signOut,
  })  : _getSession = getSession,
        _signOut = signOut,
        // On évite de bloquer l'app sur un état "unknown".
        // L'app démarre en "unauthenticated" et bascule vers "authenticated" si une session existe.
        super(const AuthState.unauthenticated()) {
    on<AuthStarted>(_onStarted);
    on<AuthRefreshRequested>(_onRefreshRequested);
    on<AuthLogoutRequested>(_onLogout);
  }

  final GetSession _getSession;
  final SignOut _signOut;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    await _checkSession(emit);
  }

  Future<void> _onRefreshRequested(
    AuthRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _checkSession(emit);
  }

  Future<void> _checkSession(Emitter<AuthState> emit) async {
    final res = await _getSession();
    res.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (session) {
        if (session == null) {
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.authenticated(session));
        }
      },
    );
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signOut();
    res.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}

