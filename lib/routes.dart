import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/models/cliente.dart';
import 'package:time_control/models/projeto.dart';
import 'package:time_control/pages/clientes/lista_page.dart';
import 'package:time_control/pages/clientes/novo_page.dart';
import 'package:time_control/pages/clientes/ver_page.dart';
import 'package:time_control/pages/configuracoes/perfil_page.dart';
import 'package:time_control/pages/projetos/lista_page.dart';
import 'package:time_control/pages/projetos/novo_page.dart';
import 'package:time_control/pages/projetos/ver_page.dart';
import 'package:time_control/root_page.dart';

import 'components/image/fullscreen_image_page.dart';

class Router {
  static Map<String, WidgetBuilder> Function(FirebaseAnalytics, FirebaseUser) routes = (analytics, firebaseUser) => {
    '/': (_) => RootPage(),
    NovoClientePage.routeName: (_) => NovoClientePage(),
    NovoProjetoPage.routeName: (_) => NovoProjetoPage(usuario: firebaseUser,),
  };

  static PageRoute Function(RouteSettings, FirebaseAnalytics, FirebaseUser)
  onGenerateRoute = (settings, analytics, firebaseUser) {
    Widget page;

    if (settings.name == PerfilPage.routeName) {
      page = PerfilPage(usuario: firebaseUser,);
    } else

    if (settings.name == ListaClientesPage.routeName) {
      page = ListaClientesPage(usuario: firebaseUser,);
    } else if (settings.name == VerClientePage.routeName) {
      final ClienteArguments args = settings.arguments;
      page = VerClientePage(cliente: args.cliente,);
    } else

    if (settings.name == ListaProjetosPage.routeName) {
      page = ListaProjetosPage(usuario: firebaseUser,);
    } else if (settings.name == VerProjetoPage.routeName) {
      final ProjetoArguments args = settings.arguments;
      page = VerProjetoPage(projeto: args.projeto,);
    } else

    if (settings.name == FullScreenImagePage.routeName) {
      final FullScreenImageArguments args = settings.arguments;
      page = FullScreenImagePage(
        key: args.key,
        imageProvider: args.imageProvider,
        tag: args.tag,
        actions: args.actions,
      );
    } else {
      page = RootPage();
    }

    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  };
}