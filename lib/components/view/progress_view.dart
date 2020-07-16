import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:time_control/services/authentication.dart';

class ProgressView extends StatelessWidget {
  final bool arrowBack;
  final bool insidePage;
  final bool isWidget;

  Auth auth = new Auth();

  ProgressView({Key key, this.arrowBack, this.insidePage, this.isWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isWidget ?? false ? _buildProgressIcon() : _buildPage();
  }

  Widget _buildProgressIcon() {
    return Container(
      width: 200,
      child: Lottie.asset('assets/animated/progress.json'),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      backgroundColor: insidePage ?? false ? Colors.black38 : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: (arrowBack ?? false) ? null : Container(),
        actions: (insidePage ?? false) ? null : <Widget>[
          FutureBuilder(builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return IconButton(
                icon: new Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Colors.red,
                ),
                tooltip: 'Sair',
                onPressed: () => auth.signOut(context),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
      body: Align(
        alignment: Alignment(0 , 0),
        child: _buildProgressIcon(),
      ),
    );
  }
}