import 'package:flutter/material.dart';
import 'package:time_control/theme.dart';

enum _BUTTON {
  raised,
  flat,
  outline,
}

Widget _buildButton({
  @required BuildContext context,
  @required _BUTTON type,
  VoidCallback onPressed,
  Color color,
  Color backgroundColor,
  Widget child,
  EdgeInsets padding,
  Axis direction = Axis.horizontal,
}) {
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  );
  padding = padding ?? const EdgeInsets.all(14.0);

  switch(type) {
    case _BUTTON.flat:
      return FlatButton(
        shape: shape,
        child: Container(
          padding: padding,
          child: child,
        ),
        color: backgroundColor,
        onPressed: onPressed,
      );
    case _BUTTON.outline:
      return OutlineButton(
        shape: shape,
        child: Container(
          padding: padding,
          child: child,
        ),
        color: backgroundColor,
        onPressed: onPressed,
      );
    default:
      return RaisedButton(
        shape: shape,
        child: Container(
          padding: padding,
          child: child,
        ),
        color: backgroundColor,
        onPressed: onPressed,
      );
  }
}

Widget _buildText({
  @required BuildContext context,
  String labelText,
  Color color,
  double fontSize = 18,
}) {
  return Text(
    labelText ?? '',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color ?? MyTheme.primaryColor,
      fontSize: fontSize,
    ),
  );
}

Widget _buildTextWithIcon({
  @required BuildContext context,
  Widget icon,
  String labelText,
  Color color,
  bool reverse,
  Axis direction,
}) {
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    direction: direction ?? Axis.horizontal,
    spacing: 8,
    textDirection: reverse ?? false ? TextDirection.rtl : TextDirection.ltr,
    children: <Widget>[
      icon is Icon ? Icon(
        icon.icon,
        color: color ?? icon.color ?? MyTheme.primaryColor[400],
        size: icon.size ?? 20.0,
      ) : Container(
        height: 25.0,
        child: icon,
      ),
      if (labelText != null) _buildText(
        context: context,
        labelText: labelText,
        color: color ?? MyTheme.primaryColor,
        fontSize: (direction ?? Axis.horizontal) == Axis.horizontal ? 18 : 14,
      ),
    ],
  );
}

class MyFlatButton extends StatelessWidget {
  final String labelText;
  final Color backgroundColor;
  final Color color;
  final Widget icon;
  final Axis direction;
  final Widget child;
  final bool reverse;
  final EdgeInsets padding;
  @required VoidCallback onPressed;

  MyFlatButton({
    this.labelText,
    this.color,
    this.icon,
    this.child,
    this.onPressed,
    this.backgroundColor,
    this.reverse,
    this.direction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context: context,
      type: _BUTTON.flat,
      onPressed: onPressed,
      color: color,
      padding: padding,
      direction: direction,
      child: child ?? (
          icon == null ?
          _buildText(
            context: context,
            labelText: labelText,
            color: color ?? MyTheme.primaryColor,
          ) :
          _buildTextWithIcon(
            context: context,
            labelText: labelText,
            reverse: reverse,
            direction: direction,
            color: onPressed == null ? Colors.black54 : (color ?? MyTheme.primaryColor),
            icon: icon,
          )
      ),
    );
  }
}

class MyRaisedButton extends StatelessWidget {
  final String labelText;
  final Color fontColor;
  final Color color;
  final Widget icon;
  final Widget child;
  final Axis direction;
  final EdgeInsets padding;
  @required VoidCallback onPressed;

  MyRaisedButton({
    this.labelText,
    this.onPressed,
    this.fontColor,
    this.color,
    this.icon,
    this.child,
    this.direction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context: context,
      padding: padding,
      onPressed: onPressed,
      type: _BUTTON.raised,
      backgroundColor: color ?? MyTheme.primaryColor,
      direction: direction,
      child: child ?? (
          icon == null ?
          _buildText(
            context: context,
            labelText: labelText,
            color: fontColor ?? Colors.white,
          ) :
          _buildTextWithIcon(
            context: context,
            labelText: labelText,
            color: fontColor ?? Colors.white,
            icon: icon,
            direction: direction,
          )
      ),
    );
  }
}

class MyOutlineButton extends StatelessWidget {
  final String labelText;
  final Color backgroundColor;
  final Color color;
  final Widget icon;
  final Widget child;
  final Axis direction;
  @required VoidCallback onPressed;

  MyOutlineButton({
    this.labelText,
    this.color,
    this.icon,
    this.child,
    this.onPressed,
    this.backgroundColor,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton(
      context: context,
      type: _BUTTON.outline,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      direction: direction,
      child: child ?? (
          icon == null ?
          _buildText(
            context: context,
            labelText: labelText,
            color: color ?? MyTheme.primaryColor,
          ) :
          _buildTextWithIcon(
            context: context,
            labelText: labelText,
            color: color ?? MyTheme.primaryColor,
            icon: icon,
            direction: direction,
          )
      ),
    );
  }
}