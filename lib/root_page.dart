import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/pages/acesso/login_page.dart';
import 'package:time_control/pages/home/home_page.dart';
import 'package:time_control/services/authentication.dart';
import 'package:time_control/theme.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  ERROR
}

class RootPage extends StatefulWidget {
  static final _app = _RootPageState();

  static updateUser(FirebaseUser value) {
    _app.update(value);
  }

  @override
  _RootPageState createState() => _app;
}

class _RootPageState extends State<RootPage> {
  final Auth _auth = new Auth();
  FirebaseUser _firebaseUser;
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    _auth.state.listen((event) {
      _firebaseUser = event;
      if (_firebaseUser == null) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        _authStatus = AuthStatus.NOT_LOGGED_IN;
      } else {
        _authStatus = AuthStatus.LOGGED_IN;
      }
      if (this.mounted) {
        setState(() {});
      }
    }).onError((err) {
      _authStatus = AuthStatus.ERROR;
      Navigator.of(context).popUntil((route) => route.isFirst);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  update(FirebaseUser value) {
    if (this.mounted) {
      setState(() => _firebaseUser = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage();
      case AuthStatus.LOGGED_IN:
        return MyHomePage(usuario: _firebaseUser,);
      case AuthStatus.ERROR:
        return _buildErrorScreen(context);
      default:
        return ProgressView();
    }
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.primaryColor,
      body: Container(
        alignment: Alignment.center,
        child: Text("Error!"),
      ),
    );
  }
}