import 'package:flutter/material.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/models/cliente.dart';

class LogoClienteContainer extends StatefulWidget {
  final Cliente cliente;
  final Function(String) onChanged;

  const LogoClienteContainer({Key key, this.cliente, this.onChanged}) : super(key: key);

  @override
  _LogoClienteContainerState createState() => _LogoClienteContainerState();
}

class _LogoClienteContainerState extends State<LogoClienteContainer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _perguntaText(),
          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }

  _perguntaText() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TitleText('Qual a logo do seu cliente?'),
    );
  }

  _body() {
    return Stack(
        children: <Widget>[
          widget.cliente.logoUrl == null ?
          Center(
              child: new Text(
                'Nenhuma imagem selecionada.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )
          ) :
          Container(
            child: Image(
              image:  NetworkImage(widget.cliente.logoUrl),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Align(
            alignment: Alignment(1, 1),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.blue,
                child: Icon(Icons.add_photo_alternate),
                elevation: 0,
                onPressed: getImage,
              ),
            ),
          ),
        ]
    );
  }

  Future getImage() async {
//    final novaImagem = await SAImage(context: context).open();
//    if (novaImagem == null) return;
//    widget.onChanged(novaImagem);
  }
}