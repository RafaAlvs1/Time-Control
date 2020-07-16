import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/buttons/my_buttons.dart';
import 'package:time_control/components/dialogs/my_dialog_progress.dart';
import 'package:time_control/components/image/fullscreen_image_page.dart';
import 'package:time_control/components/image/my_dialog_image.dart';
import 'package:time_control/components/text/my_text.dart';
import 'package:time_control/models/cliente.dart';
import 'package:time_control/models/projeto.dart';
import 'package:time_control/pages/projetos/tags.dart';

class VerProjetoPage extends StatefulWidget {
  static const routeName = '/projeto/ver';
  final Projeto projeto;

  const VerProjetoPage({Key key, this.projeto}) : super(key: key);

  @override
  _VerProjetoPageState createState() => _VerProjetoPageState();
}

class _VerProjetoPageState extends State<VerProjetoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildLogo(),
                    SizedBox(height: 30,),
                    if (widget.projeto.cliente != null) _buildCliente(),
                  ],
                ),
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return TitleText(
      widget.projeto.nome,
      tag: projetoNomeTag(widget.projeto),
      width: double.infinity,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLogo() {
    final imageProvider = widget.projeto.logoUrl != null ? NetworkImage(widget.projeto.logoUrl) : null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: imageProvider == null ? null : () {
              Navigator.pushNamed(
                context,
                FullScreenImagePage.routeName,
                arguments: FullScreenImageArguments(
                  imageProvider: imageProvider,
                  tag: projetoLogoTag(widget.projeto),
                ),
              );
            },
            child: Hero(
              tag: projetoLogoTag(widget.projeto),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: 400,
                ),
                child: widget.projeto.logoUrl == null ?
                Icon(
                  FontAwesomeIcons.projectDiagram,
                  size: 36.0,
                ) :
                Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          MyFlatButton(
            labelText: 'Mudar Logo',
            icon: Icon(FontAwesomeIcons.image),
            onPressed: _changeImage,
          ),
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
    StorageReference ref = widget.projeto.storageRef;
    final StorageUploadTask uploadTask = ref.putFile(file);

    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    _setProgress(pr, 0);

    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      setState(() {});
      switch(event.type) {
        case StorageTaskEventType.success:
          pr.update(
            progressWidget: CircularProgressIndicator(),
          );
          _updateFoto(ref, pr);
          break;
        case StorageTaskEventType.progress:
          _bytesTransferred(event.snapshot, pr);
          break;
        case StorageTaskEventType.resume:
        case StorageTaskEventType.pause:
        case StorageTaskEventType.failure:
          break;
      }
    });

    // Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
  }

  void _bytesTransferred(StorageTaskSnapshot snapshot, MyDialogProgress pr) {
    _setProgress(pr, snapshot.bytesTransferred/snapshot.totalByteCount);
  }

  void _setProgress(MyDialogProgress pr, double value) {
    pr.update(
      progressWidget: CircularProgressIndicator(
        value: value,
        backgroundColor: Colors.black26,
      ),
    );
  }

  _updateFoto(StorageReference ref, MyDialogProgress pr) async {
    final String url = await ref.getDownloadURL();
    widget.projeto.logoUrl = url;
    await widget.projeto.save();
    setState(() {});
    pr.hide();
  }

  Widget _buildActions() {
    return Wrap(
      children: <Widget>[
        MyFlatButton(
          labelText: 'Editar',
          icon: Icon(FontAwesomeIcons.solidEdit),
          direction: Axis.vertical,
          onPressed: () {

          },
        ),
        MyFlatButton(
          labelText: 'Remover',
          icon: Icon(FontAwesomeIcons.trash),
          color: Colors.red,
          direction: Axis.vertical,
          onPressed: onDelete,
        ),
      ],
    );
  }

  onDelete () async {
    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    widget.projeto.delete().then((value) {
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

  Widget _buildCliente() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _buildAvatar(widget.projeto.cliente),
        TitleText(
          widget.projeto.cliente.nome,
          width: double.infinity,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAvatar(Cliente cliente) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(8.0)),
      ),
      child: cliente.logoUrl == null ?
      Icon(
        FontAwesomeIcons.userTie,
        size: 36.0,
      ) :
      Image(
        image: NetworkImage(cliente.logoUrl),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}