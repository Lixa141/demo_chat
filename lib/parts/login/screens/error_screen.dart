part of '../login_part.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetryTapped;

  ErrorScreen({
    required this.onRetryTapped,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              locale.errorNoInternet,
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              child: Text(locale.again),
              onPressed: onRetryTapped,
            ),
          ],
        ),
      ),
    );
  }
}
