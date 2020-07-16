import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/card/my_card.dart';
import 'package:time_control/components/dialogs/my_dialog_progress.dart';
import 'package:time_control/components/image/fullscreen_image_page.dart';
import 'package:time_control/components/image/my_dialog_image.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/main.dart';
import 'package:time_control/models/usuario.dart';
import 'package:time_control/pages/configuracoes/tags.dart';
import 'package:time_control/services/authentication.dart';

class PerfilPage extends StatefulWidget {
  static const routeName = '/perfil';
  final FirebaseUser usuario;

  PerfilPage({Key key, this.usuario,}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final Auth _auth = new Auth();

  Usuario _usuario;
  StreamSubscription _usuarioSub;

  @override
  void initState() {
    super.initState();
    _usuarioSub = Usuario.minhaConta(widget.usuario.uid).listen((data) {
      setState(() => _usuario = data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usuarioSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildFoto(context),
            SizedBox(height: 20,),
            _buildInfoUser(),
            SizedBox(height: 30,),
            Container(
              width: 300.0,
              padding: EdgeInsets.all(30),
              child: MyRaisedButton(
                labelText: 'Sair',
                icon: Icon(FontAwesomeIcons.signOutAlt),
                color: Colors.red,
                onPressed: () => _auth.signOut(context),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget _buildFoto(BuildContext context) {
    final imageProvider = _usuario?.fotoUrl != null ?
    NetworkImage(_usuario.fotoUrl) :
    widget.usuario.photoUrl != null ? NetworkImage(widget.usuario.photoUrl) :
    null;

    return MyCard(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 200,
            ),
            child: Hero(
              tag: perfilFoto,
              child: imageProvider != null ? _buildImage(imageProvider) : _buildIconUser(),
            ),
          ),
          MyFlatButton(
            labelText: 'Mudar Foto',
            icon: Icon(FontAwesomeIcons.image),
            onPressed: _changeImage,
          ),
        ],
      ),
    );
  }

  Widget _buildIconUser() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Icon(
        FontAwesomeIcons.solidUserCircle,
        size: 90,
      ),
    );
  }

  Widget _buildImage(ImageProvider imageProvider) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        height: 400,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            FullScreenImagePage.routeName,
            arguments: FullScreenImageArguments(
              imageProvider: imageProvider,
              tag: perfilFoto,
            ),
          ),
          child: Image(
            image: imageProvider,
            alignment: Alignment.center,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoUser() {
    return MyCard(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Headline.opt3(
            _usuario?.nome ?? widget.usuario.displayName ?? 'Desconhecido',
            tag: perfilNome,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20,),
          _buildText(
            labelText: 'Email',
            value: _usuario?.email ?? widget.usuario.email ?? 'Sem e-mail cadastrado',
          ),
        ],
      ),
    );
  }

  Widget _buildText({
    String labelText,
    String value,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BodyText(labelText),
          TitleText(value),
        ],
      ),
    );
  }

  void _changeImage() async {
    final image = await MyPickerImage(context: context).open();
    if (image == null) return;
    _uploadFile(image);
  }

  void _uploadFile(File file) async {
    StorageReference ref = _usuario.storageRef;
    final StorageUploadTask uploadTask = ref.putFile(file);

    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
      setState(() {});
      switch(event.type) {
        case StorageTaskEventType.success:
          _updateFoto(ref, pr);
          break;
        case StorageTaskEventType.resume:
        case StorageTaskEventType.progress:
        case StorageTaskEventType.pause:
        case StorageTaskEventType.failure:
          break;
      }
    });

    // Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
  }

  _updateFoto(StorageReference ref, MyDialogProgress pr) async {
    final String url = await ref.getDownloadURL();
    final String name = await ref.getName();
    final profile = UserUpdateInfo();

    print('Name: $name, Url: $url');

    _usuario.fotoUrl = url;
    profile.photoUrl = url;

    await _usuario.update();
    await widget.usuario.updateProfile(profile);
    MyApp.updateUser();
    setState(() {});
    pr.hide();
  }
}