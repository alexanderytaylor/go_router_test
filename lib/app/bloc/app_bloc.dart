import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState.unauthenticated()) {
    on<AppAuthenticated>(_onAppAuthenticated);
    on<AppLogoutRequested>(_onLogoutRequested);
  }

  void _onAppAuthenticated(AppAuthenticated event, Emitter<AppState> emit) {
    emit(const AppState.authenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(const AppState.unauthenticated());
  }
}
