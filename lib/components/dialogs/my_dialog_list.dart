import 'package:flutter/material.dart';

import '../buttons/my_buttons.dart';

class MyDialogListItem {
  final String value;
  final String key;
  final dynamic object;

  MyDialogListItem(this.value, this.key, {this.object});
}

void MyDialogListView({
  BuildContext context,
  String title,
  List<MyDialogListItem> items,
  void Function(MyDialogListItem) onTap,
  Widget Function(dynamic) builder,
  bool barrierDismissible,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) => SADialogList(
      items: items,
      title: title,
      onTap: onTap,
      builder: builder,
    ),
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black12,
    transitionDuration: Duration(milliseconds: 200),
  );
}

class SADialogList extends StatelessWidget {
  final List<MyDialogListItem> items;
  final void Function(MyDialogListItem) onTap;
  final Widget Function(dynamic) builder;
  final String title;

  const SADialogList({
    Key key,
    this.items,
    this.onTap,
    this.title,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50),),
            ),
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  title != null ? Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.0,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ) : SizedBox(height: 20,),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        if (builder != null) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              if (onTap != null) {
                                onTap(items[index]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: builder(items[index].object),
                            ),
                          );
                        }

                        return ListTile(
                          title: Text(items[index].value),
                          onTap: () {
                            Navigator.pop(context);
                            if (onTap != null) {
                              onTap(items[index]);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MyFlatButton(
                        child: Text('Fechar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}