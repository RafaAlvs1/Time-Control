import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_control/components/dialogs/my_dialog_progress.dart';
import 'package:time_control/components/form/my_page_form.dart';
import 'package:time_control/models/projeto.dart';

import 'novo_pages/clientes_container.dart';
import 'novo_pages/logo_container.dart';
import 'novo_pages/nome_container.dart';

class NovoProjetoPage extends StatefulWidget {
  static const routeName = '/projeto/novo';
  final FirebaseUser usuario;

  const NovoProjetoPage({Key key, this.usuario}) : super(key: key);

  @override
  _NovoProjetoPageState createState() => _NovoProjetoPageState();
}

class _NovoProjetoPageState extends State<NovoProjetoPage> {
  Projeto _projeto;
  bool inProgress;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _projeto = Projeto();
    inProgress = false;
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildNome(),
      if (_projeto.nome != null) _buildLogo(),
      if (_projeto.nome != null) _buildClientes()
    ];

    return PageForm(
      scaffoldKey: _scaffoldKey,
      finishLabel: 'Concluir',
      pages: pages,
      completed: _projeto.nome != null && _projeto.cliente != null,
      onFinish: onSave,
    );
  }

  Widget _buildNome() {
    return NomeProjetoContainer(
      projeto: _projeto,
      onChanged: (nome) {
        setState(() {
          if (nome.isEmpty) {
//            _clear(0);
          } else {
            _projeto.nome = nome;
          }
        });
      },
    );
  }

  Widget _buildLogo() {
    return LogoProjetoContainer(
      projeto: _projeto,
      onChanged: (url) {},
    );
  }

  Widget _buildClientes() {
    return ClientesProjetoContainer(
      usuario: widget.usuario,
      projeto: _projeto,
      onChanged: (cliente) {
        setState(() => _projeto.cliente = cliente);
      },
    );
  }

  onSave() async {
    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    _projeto.save().then((value) {
      Navigator.of(context).pop();
    }).catchError((error) {
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      throw error;
    }).whenComplete(() => pr.hide());
  }
}