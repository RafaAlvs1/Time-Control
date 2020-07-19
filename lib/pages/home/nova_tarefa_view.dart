import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/card/my_card.dart';
import 'package:time_control/models/tarefa.dart';

class TimerCustom extends ChangeNotifier {
  Timer _timer;
  Tarefa _tarefa;

  bool get isActive => _timer == null ? false : _timer.isActive;
  String get counter => _printDuration(DateTime.now().difference(_tarefa.criadoEm.toDate()));

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void start([Tarefa tarefa]) {
    const oneSec = const Duration(seconds: 1);
    if (tarefa != null) {
      _tarefa = tarefa;
    } else {
      _tarefa = Tarefa(
        nome: 'TESTE',
        criadoEm: Timestamp.now(),
      );
      _tarefa.save();
    }
    notifyListeners();
    _timer = Timer.periodic(oneSec, (Timer timer) => notifyListeners());
  }

  void stop() {
    _tarefa.finalizadoEm =  Timestamp.now();
    _tarefa.save();
    _timer.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class Contador extends AnimatedWidget {
  TimerCustom timer;
  final Tarefa tarefa;

  Contador([this.tarefa]) : super(listenable: TimerCustom()) {
    this.timer = this.listenable;
    if (tarefa != null) {
      timer.start(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Row(
        children: <Widget>[
          timer.isActive ? stop() : start(),
        ],
      ),
    );
  }

  Widget start() {
    return MyRaisedButton(
      labelText: 'Começar',
      icon: Icon(FontAwesomeIcons.playCircle),
      color: Colors.green,
      padding: EdgeInsets.zero,
      onPressed: () => timer.start(),
    );
  }

  Widget stop() {
    return MyRaisedButton(
      labelText: timer.counter,
      icon: Icon(FontAwesomeIcons.stopCircle),
      color: Colors.red,
      padding: EdgeInsets.zero,
      onPressed: () => timer.stop(),
    );
  }
}
