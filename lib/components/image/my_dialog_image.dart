import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_control/components/card/my_card.dart';

BuildContext _context;

class MyPickerImage {
  File _file;
  File get image => _file;

  MyPickerImage({@required BuildContext context}) {
    _context = context;
  }

  List<Map<String, dynamic>> opcoes = [{
    'icon': FontAwesomeIcons.solidImages,
    'label': 'Galeria',
  }, {
    'icon': FontAwesomeIcons.camera,
    'label': 'Câmera',
  }];

  Future<File> open() async {
    if (MediaQuery.of(_context).viewInsets.bottom > 0) {
      FocusScope.of(_context).requestFocus(FocusNode());
    }
    var result = await showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: MyCard(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: opcoes.map((value) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(value),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(value['icon'], size: 48,),
                          Text(value['label']),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
    );

    if (result == null) {
      return null;
    }

    var _image = await ImagePicker.pickImage(
        source: result == opcoes[0] ? ImageSource.gallery : ImageSource.camera
    );

    if (_image == null) {
      return null;
    }

    _file = _image;
    return _file;
  }
}