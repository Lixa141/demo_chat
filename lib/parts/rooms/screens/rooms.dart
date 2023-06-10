part of '../rooms_part.dart';

class Rooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<LoginBloc>().add(LoginExited()),
          ),
          title: Text(locale.rooms),
        ),
        body: BlocConsumer<RoomsBloc, RoomsState>(
            listener: (context, state) {
              if (state is RoomsLoadSuccess) {
                RoomsLoadSuccess _state = state;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                        content: Text(_state.connectionStatus ==
                                ConnectionStatus.connecting
                            ? locale.connectionStatusRetry
                            : locale.connectionStatusRestored)),
                  );
              }
            },
            listenWhen: (previous, current) =>
                (previous is RoomsLoadSuccess && current is RoomsLoadSuccess) &&
                current.connectionStatus != previous.connectionStatus,
            builder: (context, state) {
              if (state is RoomsLoadFailed)
                return ErrorScreen(
                    onRetryTapped: () => context
                        .read<RoomsBloc>()
                        .add(RoomsFetched(user: state.user)));
              else if (state is RoomsLoadSuccess)
                return RoomsDisplay(state: state);
              else
                return SplashScreen();
            }));
  }
}
