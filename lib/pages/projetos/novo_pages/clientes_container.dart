import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/models/cliente.dart';
import 'package:time_control/models/projeto.dart';
import 'package:time_control/pages/clientes/lista_page.dart';

class ClientesProjetoContainer extends StatefulWidget {
  final FirebaseUser usuario;
  final Projeto projeto;
  final Function(Cliente) onChanged;

  const ClientesProjetoContainer({
    Key key,
    @required this.projeto,
    @required this.onChanged,
    @required this.usuario,
  }) : super(key: key);

  @override
  _ClientesProjetoContainerState createState() => _ClientesProjetoContainerState();
}

class _ClientesProjetoContainerState extends State<ClientesProjetoContainer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _perguntaText(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: widget.projeto.cliente == null ? _listaClientes() : _clienteEscolhido(),
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
        'De quem é este projeto?',
      ),
    );
  }

  Widget _clienteEscolhido() {
    return Column(
      children: [
        TitleText(
          widget.projeto.cliente.nome,
//          tag: clienteNomeTag(widget.cliente),
          width: double.infinity,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        _buildLogo(),
        MyRaisedButton(
          labelText: 'Mudar',
          onPressed: () {
            widget.onChanged(null);
          },
        )
      ],
    );
  }

  Widget _buildLogo() {
    final imageProvider = widget.projeto.cliente.logoUrl != null ? NetworkImage(widget.projeto.cliente.logoUrl) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 200,
            maxHeight: 400,
          ),
          child: imageProvider == null ?
          Icon(
            FontAwesomeIcons.userTie,
            size: 36.0,
          ) :
          Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _listaClientes() {
    return ListaClienteContainer(
      usuario: widget.usuario,
      onTap: widget.onChanged,
    );
  }
}