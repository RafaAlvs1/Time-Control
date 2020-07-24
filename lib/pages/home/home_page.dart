import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_bottom_bar.dart';
import 'package:time_control/pages/clientes/lista_page.dart';
import 'package:time_control/pages/configuracoes/perfil_page.dart';
import 'package:time_control/pages/projetos/lista_page.dart';
import 'package:time_control/pages/tarefas/tasks_view.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseUser usuario;

  const MyHomePage({Key key, this.usuario}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  bool _controlAnimation = true;
  int _currentIndex = 0;

  final _duration = Duration(milliseconds: 300);
  final _curve = Curves.easeIn;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (_controlAnimation) {
              setState(() => _currentIndex = index);
            } else {
              if (_currentIndex == index) {
                setState(() => _controlAnimation = true);
              }
            }
          },
          children: <Widget>[
            TasksView(usuario: widget.usuario,),
            ListaProjetosPage(usuario: widget.usuario,),
            ListaClientesPage(usuario: widget.usuario,),
            PerfilPage(usuario: widget.usuario,),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return MyBottomBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) {
        _controlAnimation = false;
        setState(() => _currentIndex = index);
        _pageController.animateToPage(index, duration: _duration, curve: _curve);
      },
      items: [
        MyBottomBarItem(icon: Icon(FontAwesomeIcons.clock), title: Text('Tarefas')),
        MyBottomBarItem(icon: Icon(FontAwesomeIcons.projectDiagram), title: Text('Projetos')),
        MyBottomBarItem(icon: Icon(FontAwesomeIcons.userTie), title: Text('Clientes')),
        MyBottomBarItem(icon: Icon(FontAwesomeIcons.solidUserCircle), title: Text('Perfil')),
      ],
    );
  }
}