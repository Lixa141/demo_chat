part of '../login_part.dart';

class LoginFormInput extends StatefulWidget {
  @override
  _LoginFormInputState createState() => _LoginFormInputState();
}

class _LoginFormInputState extends State<LoginFormInput> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';

  void _trySubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSubmitted(username: _userName));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;

    return Scaffold(
        body: Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  autocorrect: true,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  enableSuggestions: false,
                  validator: (value) {
                    if (!RegExp(r'^[A-Za-z0-9А-ЯЁа-яё -]{3,20}$')
                        .hasMatch(value ?? '')) return locale.loginHint;
                    return null;
                  },
                  decoration: InputDecoration(labelText: locale.userName),
                  onSaved: (value) {
                    _userName = value ?? '';
                  },
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text(locale.enter),
                  onPressed: _trySubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
