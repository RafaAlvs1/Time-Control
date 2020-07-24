import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_fab.dart';
import 'package:time_control/components/view/grid_item_view.dart';
import 'package:time_control/components/view/progress_view.dart';
import 'package:time_control/models/projeto.dart';
import 'package:time_control/pages/projetos/tags.dart';

import 'novo_page.dart';
import 'ver_page.dart';

List<Projeto> initialList;

class ListaProjetosPage extends StatefulWidget {
  static const routeName = '/projetos/lista';
  final FirebaseUser usuario;

  const ListaProjetosPage({Key key, this.usuario}) : super(key: key);

  @override
  _ListaProjetosPageState createState() => _ListaProjetosPageState();
}

class _ListaProjetosPageState extends State<ListaProjetosPage> {
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
      body: _buildBody(),
      floatingActionButton: _buildAddBtn(),
    );
  }

  Widget _buildAddBtn() {
    return MyFAB(
      controller: _scrollController,
      child: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(NovoProjetoPage.routeName),
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Projeto>>(
      stream: Projeto.lista(widget.usuario.uid),
      initialData: initialList,
      builder: (BuildContext context, AsyncSnapshot<List<Projeto>> snapshot) {
        if (snapshot.hasError) {
          return _buildCenterText('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return ProgressView(insidePage: true,);
        } else if (!snapshot.hasData) {
          return _buildCenterText('Problema recebendo os dados');
        } else {
          initialList = snapshot.data;
          if (snapshot.data.length == 0) {
            return _buildCenterText('Você não possui nenhum projeto');
          } else {
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: snapshot.data.map((data) => _buildItem(data)).toList(),
                  ),
                ),
              ],
            );
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

  Widget _buildItem(Projeto projeto) {
    return GridItemView(
      labelText: projeto.nome,
      labelTag: projetoNomeTag(projeto),
      imageUrl: projeto.logoUrl,
      imageTag: projetoLogoTag(projeto),
      defaulIcon: Icon(
        FontAwesomeIcons.projectDiagram,
        size: 36.0,
      ),
      onTap: () => Navigator.of(context).pushNamed(
        VerProjetoPage.routeName,
        arguments: ProjetoArguments(projeto),
      ),
    );
  }
}