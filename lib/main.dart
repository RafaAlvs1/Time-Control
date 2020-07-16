import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_control/root_page.dart';
import 'package:time_control/routes.dart';
import 'package:time_control/services/authentication.dart';
import 'package:time_control/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static final _app = _MyAppState();

  static updateUser() {
    _app.update();
  }

  @override
  _MyAppState createState() => _app;
}

class _MyAppState extends State<MyApp> {
  final Auth _auth = new Auth();
  FirebaseUser _firebaseUser;
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    _auth.state.listen((event) => _firebaseUser = event);
    FirebaseAuth.instance.setLanguageCode('pt-BR');
  }

  update() {
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() => _firebaseUser = value);
      RootPage.updateUser(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Control',
      theme: ThemeData(
        scaffoldBackgroundColor: MyTheme.backgroundColor,
        brightness: Brightness.light,
        primarySwatch: MyTheme.primaryColor,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      initialRoute: '/',
      routes: Router.routes(analytics, _firebaseUser),
      onGenerateRoute: (settings) => Router.onGenerateRoute(settings, analytics, _firebaseUser,),
    );
  }
}
