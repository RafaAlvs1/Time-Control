import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/models/tarefa.dart';
import 'package:time_control/pages/home/task_item_view.dart';

enum TarefaStatus {
  NOT_DETERMINED,
  NOT_DATA,
  HAS_DATA,
  ERROR
}

class LastTasksPage extends StatefulWidget {
  final FirebaseUser usuario;

  const LastTasksPage({Key key, this.usuario}) : super(key: key);

  @override
  _LastTasksPageState createState() => _LastTasksPageState();
}

class _LastTasksPageState extends State<LastTasksPage> {
  StreamSubscription _subscription;
  TarefaStatus _status;
  String _error;

  List<Tarefa> _tarefas;

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
    switch(_status) {
      case TarefaStatus.NOT_DATA:
        return SliverToBoxAdapter(
          child: _buildCenterText('Problema recebendo os dados'),
        );
        break;
      case TarefaStatus.HAS_DATA:
        if (_tarefas.length == 0) {
          return SliverToBoxAdapter(
            child: _buildCenterText('Você ainda não possui nenhuma tarefa'),
          );
        } else {
          return SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                Tarefa tarefa = _tarefas[index];
                return _buildItem(tarefa);
              },
              childCount: _tarefas.length,
            ),
          );
        }
        break;
      case TarefaStatus.ERROR:
        return SliverToBoxAdapter(
          child: _buildCenterText('Error: $_error'),
        );
        break;
      default:
        return SliverToBoxAdapter(
          child: ProgressView(isWidget: true,),
        );
    }
  }

  Widget _buildCenterText(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Tarefa tarefa) {
    return TaskItemView(
      tarefa: tarefa,
    );
  }
}