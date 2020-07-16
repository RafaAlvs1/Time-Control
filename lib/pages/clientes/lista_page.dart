import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_fab.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/components/view/grid_item_view.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/models/cliente.dart';

import 'novo_page.dart';
import 'tags.dart';
import 'ver_page.dart';

class ListaClientesPage extends StatefulWidget {
  static const routeName = '/clientes/lista';
  final FirebaseUser usuario;

  const ListaClientesPage({Key key, this.usuario}) : super(key: key);

  @override
  _ListaClientesPageState createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListaClienteContainer(
        usuario: widget.usuario,
        controller: _scrollController,
        onTap: (cliente) => Navigator.of(context).pushNamed(
          VerClientePage.routeName,
          arguments: ClienteArguments(cliente),
        ),
      ),
      floatingActionButton: _buildAddBtn(),
    );
  }

  Widget _buildAddBtn() {
    return MyFAB(
      controller: _scrollController,
      child: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(NovoClientePage.routeName),
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}

class ListaClienteContainer extends StatefulWidget {
  final FirebaseUser usuario;
  final ScrollController controller;
  final Function(Cliente) onTap;
  final bool onlyRead;

  const ListaClienteContainer({Key key, @required this.usuario, this.controller, this.onlyRead = false, this.onTap}) : super(key: key);

  @override
  _ListaClienteContainerState createState() => _ListaClienteContainerState();
}

class _ListaClienteContainerState extends State<ListaClienteContainer> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return StreamBuilder<List<Cliente>>(
      stream: Cliente.lista(widget.usuario.uid),
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (snapshot.hasError) {
          return _buildCenterText('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ProgressView(insidePage: true,);
          default:
            if (!snapshot.hasData) {
              return _buildCenterText('Problema recebendo os dados');
            } else {
              if (snapshot.data.length == 0) {
                return _buildCenterText('Você não possui nenhum cliente');
              } else {
                return CustomScrollView(
                  controller: widget.controller,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.count(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: snapshot.data.map((cliente) => _buildItem(cliente)).toList(),
                      ),
                    ),
                  ],
                );
              }
            }
        }
      },
    );
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

  Widget _buildItem(Cliente cliente) {
    return GridItemView(
      labelText: cliente.nome,
      labelTag: clienteNomeTag(cliente),
      imageUrl: cliente.logoUrl,
      imageTag: clienteLogoTag(cliente),
      defaulIcon: Icon(
        FontAwesomeIcons.userTie,
        size: 36.0,
      ),
      onTap: widget.onTap == null ? null : () {
        widget.onTap(cliente);
      },
    );
  }
}