part of '../login_part.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginInput) {
        return LoginFormInput();
      } else if (state is LoginSuccess) {
        return RepositoryProvider(
          create: (context) => MessageRepository(user: state.user),
          child: BlocProvider(
              create: (context) => RoomsBloc(
                  messageRepository: context.read<MessageRepository>(),
                  roomsRepository:
                      RoomsRepository(roomsDataProvider: RoomsDataProvider()))
                ..add(RoomsOpened(user: state.user)),
              child: Rooms()),
        );
      } else if (state is LoginFailed) {
        return ErrorScreen(
            onRetryTapped: () => context.read<LoginBloc>().add(LoginRetried()));
      } else
        return SplashScreen();
    });
  }
}
