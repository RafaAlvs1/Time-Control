import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/pages/home/bottom_bar_view.dart';
import 'package:time_control/pages/home/last_tasks_page.dart';

import 'nova_tarefa_view.dart';


class MyHomePage extends StatefulWidget {
  final FirebaseUser usuario;

  const MyHomePage({Key key, this.usuario}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Bar'),
      ),
      bottomNavigationBar: BottomBarView(
        usuario: widget.usuario,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: _buildCardTask(),
            ),
          ),
          _buildLastTaks(),
        ],
      ),
    );
  }

  Widget _buildCardTask() {
    return Contador();
  }

  Widget _buildLastTaks() {
    return LastTasksPage(
      usuario: widget.usuario,
    );
  }
}