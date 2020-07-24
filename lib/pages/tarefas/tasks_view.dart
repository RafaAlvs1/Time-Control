import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/models/tarefa.dart';

import 'last_tasks_page.dart';
import 'nova_tarefa_view.dart';
import 'task_item_view.dart';

enum TarefaStatus {
  NOT_DETERMINED,
  NOT_DATA,
  HAS_DATA,
  ERROR
}

class TasksView extends StatefulWidget {
  final FirebaseUser usuario;

  const TasksView({Key key, this.usuario}) : super(key: key);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  List<Tarefa> _tarefas;
  TarefaStatus _status;
  StreamSubscription _subscription;
  String _error;

  @override
  void initState() {
    super.initState();
    _status = TarefaStatus.NOT_DETERMINED;
    _error = "";
    _subscription = Tarefa.lista(widget.usuario.uid).listen((event) {
      if (event == null) {
        _status = TarefaStatus.NOT_DATA;
      } else {
        _status = TarefaStatus.HAS_DATA;
        _tarefas = event;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    switch(_status) {
      case TarefaStatus.NOT_DATA:
        return _buildCenterText('Problema recebendo os dados');
      case TarefaStatus.HAS_DATA:
        return _tarefas.length == 0
            ? _buildCenterText('Você ainda não possui nenhuma tarefa')
            : _buildLastTaks();
      case TarefaStatus.ERROR:
        return _buildCenterText('Error: $_error');
      default:
        return Center(child: ProgressView(isWidget: true,));
    }
  }

  Widget _buildCenterText(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }

  Widget _buildLastTaks() {
    Tarefa incompleta;
    List<Tarefa> completas;

    if (_tarefas.length > 0) {
      if (_tarefas[0].finalizadoEm == null) {
        incompleta = _tarefas[0];
        completas = _tarefas.sublist(1);
      } else {
        completas = _tarefas;
      }
    } else {
      completas = _tarefas;
    }

    return Column(
      children: <Widget>[
        incompleta == null ? Contador() : TaskItemView(tarefa: incompleta),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              LastTasksPage(
                tarefas: completas,
              ),
            ],
          ),
        ),
      ],
    );
  }
}