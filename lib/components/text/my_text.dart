import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:time_control/theme.dart';

Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
    ) {
  Hero hero = toHeroContext.widget as Hero;
  dynamic text = hero.child;

  return Material(
    color: Colors.transparent,
    child: AutoSizeText(
      (text as dynamic).data,
      maxLines: text.maxLines,
      textScaleFactor: 0.5,
      style: text.style.merge(TextStyle(
        fontSize: text.style.fontSize < 100 ? 100 : text.style.fontSize,
      )),
      textAlign: text.textAlign ?? TextAlign.center,
    ),
  );
}

Widget _buildText(
    String text, {
      TextAlign textAlign,
      TextStyle style,
      int maxLines,
      TextOverflow overflow,
      String tag,
      bool autosize,
    }) {

  final wText = !(autosize ?? false) ? Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: style,
    textAlign: textAlign,
  ) : AutoSizeText(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: style,
    textAlign: textAlign,
  );

  return tag != null ? Hero(
    tag: tag,
    flightShuttleBuilder: _flightShuttleBuilder,
    child: wText,
  ) : Material(
    color: Colors.transparent,
    child: wText,
  );
}

class Headline extends StatelessWidget {
  final String text;
  final String tag;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;

  const Headline(this.text, {
    Key key,
    this.textAlign,
    this.style,
    this.maxLines,
    this.overflow,
    this.tag,
  }) : super(key: key);


  factory Headline.opt3(String text, {
    TextAlign textAlign,
    TextStyle style,
    int maxLines,
    TextOverflow overflow,
    String tag,
  }) {
    return Headline(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      tag: tag,
      style: MyTextStyle.headline3.merge(style),
    );
  }

  factory Headline.opt4(String text, {
    TextAlign textAlign,
    TextStyle style,
    int maxLines,
    TextOverflow overflow,
    String tag,
  }) {
    return Headline(
      text,
      tag: tag,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: MyTextStyle.headline4.merge(style),
    );
  }


  factory Headline.opt5(String text, {TextAlign textAlign, TextStyle style}) {
    return Headline(
      text,
      textAlign: textAlign,
      style: MyTextStyle.headline5.merge(style),
    );
  }

  factory Headline.opt6(String text) {
    return Headline(text);
  }

  @override
  Widget build(BuildContext context) {
    return _buildText(
      text,
      tag: tag,
      maxLines: maxLines,
      overflow: overflow,
      style: MyTextStyle.headline6.merge(style),
      textAlign: textAlign,
    );
  }
}


class TitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final EdgeInsets padding;
  final double width;
  final String tag;
  final bool autosize;

  const TitleText(this.text, {
    Key key,
    this.textAlign,
    this.style,
    this.maxLines,
    this.overflow,
    this.padding,
    this.width,
    this.tag,
    this.autosize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _buildText(
        text,
        tag: tag,
        autosize: autosize,
        maxLines: maxLines,
        overflow: overflow,
        style: MyTextStyle.subtitle.merge(style),
        textAlign: textAlign,
      ),
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final String tag;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;

  const BodyText(this.text, {
    Key key,
    this.textAlign,
    this.style,
    this.maxLines,
    this.overflow,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildText(
      text,
      tag: tag,
      maxLines: maxLines,
      overflow: overflow,
      style: MyTextStyle.bodyText.merge(style),
      textAlign: textAlign,
    );
  }
}

class CaptionText extends StatelessWidget {
  final String text;
  final String tag;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;

  const CaptionText(this.text, {
    Key key,
    this.textAlign,
    this.style,
    this.maxLines,
    this.overflow,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildText(
      text,
      tag: tag,
      maxLines: maxLines,
      overflow: overflow,
      style: MyTextStyle.captionText.merge(style),
      textAlign: textAlign,
    );
  }
}