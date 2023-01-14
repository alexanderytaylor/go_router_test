part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppAuthenticated extends AppEvent {
  const AppAuthenticated();
}
