part of '../login_part.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInput()) {
    on(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    print("LoginBloc event $event");
    final status =
        await ConnectivityCheckService.connectivityCheck(['nane.tada.team']);
    if (status == ConnectionStatus.active)
      emit(
          LoginSuccess(user: User(username: event.username, uid: Uuid().v1())));
    else
      emit(LoginFailed());
  }

  @override
  LoginState fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'LoginSuccess')
      return LoginSuccess(user: User.fromJson(json['user']));
    else
      return LoginInput();
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    if (state is LoginSuccess)
      return {'type': 'LoginSuccess', 'user': state.user.toJson()};
    else if (state is LoginInput)
      return {'type': 'LoginInput'};
    else
      return null;
  }
}
