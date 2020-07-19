import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_control/components/card/my_card.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/models/tarefa.dart';
import 'package:time_control/pages/home/nova_tarefa_view.dart';
import 'package:time_control/theme.dart';

class TaskItemView extends StatelessWidget {
  final Tarefa tarefa;

  const TaskItemView({Key key, @required this.tarefa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tarefa.finalizadoEm == null) {
      return _TaskItemInProgressView(tarefa: tarefa,);
    } else {
      return _TaskItemCompletedView(tarefa: tarefa,);
    }
  }
}

class _TaskItemInProgressView extends StatelessWidget {
  final Tarefa tarefa;

  const _TaskItemInProgressView({Key key, @required this.tarefa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyCard(
        padding: EdgeInsets.zero,
        child: Contador(tarefa),
      ),
    );
  }
}

class _TaskItemCompletedView extends StatelessWidget {
  final Tarefa tarefa;

  const _TaskItemCompletedView({Key key, @required this.tarefa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MyCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildNameAndIconClient(),
                      _buildProjectAndClient(),
                    ],
                  ),
                ),
                Container(
                  color: MyTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10,),
                  child: _buildStartAndStop(),
                ),
              ],
            ),
          ),
          _buildActionRow(),
        ],
      ),
    );
  }

  String _totalTimeTask(Tarefa tarefa) {
    if (tarefa.finalizadoEm == null || tarefa.criadoEm == null) {
      return '';
    }
    return _printDuration(tarefa.finalizadoEm.toDate().difference(tarefa.criadoEm.toDate()));
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          color: Colors.red,
          iconSize: 18,
          icon: Icon(FontAwesomeIcons.trash),
          onPressed: () => tarefa.delete(),
        ),
      ],
    );
  }

  Widget _buildNameAndIconClient() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Headline(
            tarefa.nome ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(8.0)),
              ),
              child: tarefa.projeto?.logoUrl == null ?
              Icon(
                FontAwesomeIcons.projectDiagram,
                size: 20.0,
              ) :
              Image(
                image: NetworkImage(tarefa.projeto.logoUrl),
                fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ],
    );
  }

  Widget _buildProjectAndClient() {
    final style = TextStyle(
      fontSize: 12,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BodyText(
          tarefa.projeto?.nome ?? 'xx',
          style: style,
        ),
        BodyText(
          ' - ',
          style: style,
        ),
        BodyText(
          tarefa.cliente?.nome ?? 'xx',
          style: style,
        ),
      ],
    );
  }

  Widget _buildStartAndStop() {
    final detailTimeStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final totalTimeStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 18,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CaptionText(
                tarefa.criadoEm != null ? DateFormat.Hms().format(tarefa.criadoEm?.toDate()) : 'xx',
                style: detailTimeStyle,
              ),
              CaptionText(
                ' - ',
                style: detailTimeStyle,
              ),
              CaptionText(
                tarefa.finalizadoEm != null ? DateFormat.Hms().format(tarefa.finalizadoEm?.toDate()) : 'xx',
                style: detailTimeStyle,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.timer,
              size: totalTimeStyle.fontSize,
              color: Colors.white,
            ),
            SizedBox(width: 10,),
            BodyText(
              _totalTimeTask(tarefa),
              style: totalTimeStyle,
            ),
          ],
        ),
      ],
    );
  }
}