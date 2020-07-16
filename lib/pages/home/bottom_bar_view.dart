import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/pages/clientes/lista_page.dart';
import 'package:time_control/pages/configuracoes/perfil_page.dart';
import 'package:time_control/pages/configuracoes/tags.dart';
import 'package:time_control/pages/projetos/lista_page.dart';

class BottomBarView extends StatelessWidget {
  final FirebaseUser usuario;

  const BottomBarView({Key key, this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBottomBar(context);
  }

  _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
//      color: MyTheme.primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(FontAwesomeIcons.solidChartBar,),
              onPressed: ()  {},
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.projectDiagram,),
              onPressed: () => Navigator.pushNamed(context, ListaProjetosPage.routeName,),
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.userTie,),
              onPressed: () => Navigator.pushNamed(context, ListaClientesPage.routeName,),
            ),
            IconButton(
              icon: _buildFoto(),
              onPressed: ()  => Navigator.pushNamed(context, PerfilPage.routeName,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoto() {
    return Hero(
      tag: perfilFoto,
      child: usuario?.photoUrl == null ?
      Icon(FontAwesomeIcons.solidUserCircle,) :
      Container(
        width: 60,
        height: 60,
        child: ClipOval(
          child: Image(
            image: NetworkImage(usuario.photoUrl),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}