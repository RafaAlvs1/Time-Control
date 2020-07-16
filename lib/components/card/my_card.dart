import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color backgroundColor;
  final LinearGradient gradient;
  final BoxBorder border;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final Function() onTap;

  const MyCard({
    Key key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.gradient,
    this.boxShadow,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        gradient: gradient,
        border: border,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8.0)),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black54.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 30,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: padding ?? EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}