import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_control/components/card/my_card.dart';
import 'package:time_control/components/text/my_text.dart';

class GridItemView extends StatelessWidget {
  final String labelTag;
  final String labelText;
  final String imageTag;
  final String imageUrl;
  final Icon defaulIcon;
  final Function() onTap;

  const GridItemView({Key key, this.labelText, this.imageUrl, this.defaulIcon, this.onTap, this.labelTag, this.imageTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildItem();
  }

  Widget _buildItem() {
    return MyCard(
      padding: const EdgeInsets.all(14.0),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Hero(
            tag: imageTag,
            child: _buildAvatar(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TitleText(
              labelText ?? '',
              tag: labelTag,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(8.0),
      decoration: new BoxDecoration(
        color: imageUrl == null ? Colors.teal : null,
        borderRadius: new BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUrl == null ?
        Icon(
          defaulIcon.icon ?? FontAwesomeIcons.projectDiagram,
          color: defaulIcon.color ?? Colors.white,
          size: defaulIcon.size ?? 36.0,
        ) :
        Image(
          image: NetworkImage(imageUrl),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}