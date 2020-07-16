import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/card/my_card.dart';
import 'package:time_control/pages/home/bottom_bar_view.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildCardTask(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTask() {
    return Contador();
  }
}