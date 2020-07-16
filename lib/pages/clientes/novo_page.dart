import 'package:flutter/material.dart';
import 'package:time_control/components/dialogs/my_dialog_progress.dart';
import 'package:time_control/components/form/my_page_form.dart';
import 'package:time_control/models/cliente.dart';
import 'package:time_control/pages/clientes/novo_pages/logo_container.dart';

import 'novo_pages/nome_container.dart';

class NovoClientePage extends StatefulWidget {
  static const routeName = '/clientes/novo';

  @override
  _NovoClientePageState createState() => _NovoClientePageState();
}

class _NovoClientePageState extends State<NovoClientePage> {
  Cliente _cliente;
  bool inProgress;

  @override
  void initState() {
    super.initState();
    _cliente = Cliente();
    inProgress = false;
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildNome(),
      if (_cliente.nome != null) _buildLogo()
    ];

    return PageForm(
      finishLabel: 'Concluir',
      pages: pages,
      completed: pages.length == 2,
      onFinish: onSave,
    );
  }

  Widget _buildNome() {
    return NomeClienteContainer(
      cliente: _cliente,
      onChanged: (nome) {
        setState(() {
          if (nome.isEmpty) {
//            _clear(0);
          } else {
            _cliente.nome = nome;
          }
        });
      },
    );
  }

  Widget _buildLogo() {
    return LogoClienteContainer(
      cliente: _cliente,
      onChanged: (url) {},
    );
  }

  onSave() async {
    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    _cliente.save().then((value) {
      Navigator.of(context).pop();
    }).catchError((error) {
      Scaffold.of(context)
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