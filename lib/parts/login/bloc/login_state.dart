part of '../login_part.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInput extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class LoginFailed extends LoginState {}
