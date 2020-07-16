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
import 'package:time_control/pages/clientes/tags.dart';

class VerClientePage extends StatefulWidget {
  static const routeName = '/clientes/ver';
  final Cliente cliente;

  const VerClientePage({Key key, this.cliente}) : super(key: key);

  @override
  _VerClientePageState createState() => _VerClientePageState();
}

class _VerClientePageState extends State<VerClientePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TitleText(
                    widget.cliente.nome,
                    tag: clienteNomeTag(widget.cliente),
                    width: double.infinity,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildLogo(),
                ],
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    final imageProvider = widget.cliente.logoUrl != null ? NetworkImage(widget.cliente.logoUrl) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: imageProvider == null ? null : () {
            Navigator.pushNamed(
              context,
              FullScreenImagePage.routeName,
              arguments: FullScreenImageArguments(
                imageProvider: imageProvider,
                tag: clienteLogoTag(widget.cliente),
              ),
            );
          },
          child: Hero(
            tag: clienteLogoTag(widget.cliente),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight: 400,
              ),
              child: widget.cliente.logoUrl == null ?
              Icon(
                FontAwesomeIcons.userTie,
                size: 36.0,
              ) :
              Image(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        MyFlatButton(
          labelText: 'Mudar Logo',
          icon: Icon(FontAwesomeIcons.image),
          onPressed: _changeImage,
        ),
      ],
    );
  }

  void _changeImage() async {
    final image = await MyPickerImage(context: context).open();
    if (image == null) return;
    _uploadFile(image);
  }

  void _uploadFile(File file) async {
    StorageReference ref = widget.cliente.storageRef;
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
    widget.cliente.logoUrl = url;
    await widget.cliente.save();
    setState(() {});
    pr.hide();
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
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
      ),
    );
  }

  onDelete () async {
    MyDialogProgress  pr = MyDialogProgress(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    widget.cliente.delete().then((value) {
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