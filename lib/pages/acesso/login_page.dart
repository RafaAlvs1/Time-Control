import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/input/my_input.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/services/authentication.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login';

  final FirebaseAnalytics analytics;

  const LoginPage({this.analytics, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final Auth auth = new Auth();
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage = "";

  bool _isLoading;

  bool isVisible = false;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      bool userResult = false;
      FocusScope.of(context).requestFocus(FocusNode());
      try {
        userResult = await auth.signIn(
            email: _email,
            password: _password
        );
        print('Signed in: $userResult');

        if (!userResult) {
          String errorMessage = "Não foi possível realizar a autenticação";
          setState(() {
            _isLoading = false;
            _errorMessage = errorMessage;
          });
        }
//        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message; // TODO: Problema ao tentar recuperar o erro na get de message
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _loginForm(),
              if (_isLoading) ProgressView(insidePage: true,),
            ],
          ),
        )
    );
  }

  _loginForm() => Center(
    child: SingleChildScrollView(
      child: new Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            constraints: BoxConstraints(
              maxWidth: 350.0,
            ),
            child: Column(
              children: <Widget>[
                showEmailInput(),
                showPasswordInput(),
                if (_errorMessage != null && _errorMessage.length > 0) showErrorMessage(),
                SizedBox(height: 30,),
                showButtonLogin(),
              ],
            ),
          )
      ),
    ),
  );

  Widget showEmailInput() => MyInput(
    hintText: "E-mail",
    labelText: "Digite seu e-mail",
    keyboardType: TextInputType.emailAddress,
    icon: new Icon(FontAwesomeIcons.envelope),
    onSaved: (value) => _email = value.trim(),
  );

  Widget showPasswordInput() => MyInput(
    obscureText: !isVisible,
    hintText: "Digite sua senha",
    labelText: "Senha",
    icon: Icon(FontAwesomeIcons.lock),
    suffixIcon: IconButton(
      padding: EdgeInsets.all(0),
      icon: Icon(isVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash),
      onPressed: () {
        setState(() => isVisible = !isVisible);
      },
    ),
    onSaved: (value) => _password = value.trim(),
  );

  Widget showErrorMessage() => Text(
    _errorMessage,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: 13.0,
        color: Colors.red,
        height: 1.0,
        fontWeight: FontWeight.bold
    ),
  );

  Widget showButtonLogin() => Container(
    width: double.infinity,
    child: MyRaisedButton(
      labelText: "Acessar",
      onPressed: validateAndSubmit,
    ),
  );
}
