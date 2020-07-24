import 'package:flutter/material.dart';
import 'package:time_control/models/tarefa.dart';
import 'package:time_control/pages/home/task_item_view.dart';

class LastTasksPage extends StatelessWidget {
  final List<Tarefa> tarefas;

  const LastTasksPage({Key key, this.tarefas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      // Use a delegate to build items as they're scrolled on screen.
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          Tarefa tarefa = tarefas[index];
          return _buildItem(tarefa);
        },
        childCount: tarefas.length,
      ),
    );
  }

  Widget _buildItem(Tarefa tarefa) {
    return TaskItemView(
      tarefa: tarefa,
    );
  }
}