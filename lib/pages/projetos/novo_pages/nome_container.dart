import 'package:flutter/material.dart';
import 'package:time_control/components/input/my_input.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/models/projeto.dart';

class NomeProjetoContainer extends StatefulWidget {
  final Projeto projeto;
  final Function(String) onChanged;

  NomeProjetoContainer({
    Key key,
    @required this.projeto,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _NomeProjetoContainerState createState() => _NomeProjetoContainerState();
}

class _NomeProjetoContainerState extends State<NomeProjetoContainer> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.projeto.nome);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _perguntaText(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _body(),
            ),
          ),
        ],
      ),
    );
  }

  _perguntaText() {
    return Padding(
      padding: const EdgeInsets.all(14.0,),
      child: TitleText(
        'Qual o nome do projeto?',
      ),
    );
  }

  Widget _body() {
    return MyInput(
      controller: _controller,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 1,
      hintText: "Escreva aqui...",
      onChanged: widget.onChanged,
    );
  }
}