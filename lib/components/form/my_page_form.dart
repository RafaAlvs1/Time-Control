import 'package:flutter/material.dart';
import 'package:time_control/theme.dart';

import '../buttons/my_buttons.dart';

final _duration = Duration(milliseconds: 300);
final _curve = Curves.easeIn;
int _page;

class PageForm extends StatefulWidget {
  final String title;
  int initialPage;
  final List<Widget> pages;
  final Function() onFinish;
  final String finishLabel;
  final String nextLabel;
  final bool disabled;
  final bool completed;
  final PageController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  PageForm({
    Key key,
    this.title,
    this.onFinish,
    this.finishLabel,
    this.nextLabel,
    this.disabled,
    this.completed,
    @required this.pages,
    this.initialPage = 0, this.scaffoldKey,
  }) : controller = new PageController(), super(key: key);

  nextPage() {
    controller.nextPage(duration: _duration, curve: _curve);
  }

  @override
  _PageFormState createState() {
    _page = initialPage;
    return _PageFormState();
  }
}

class _PageFormState extends State<PageForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: widget.title == null ? null : AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: (widget.pages ?? []).length == 0 ? Container() : Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: widget.disabled ?? false ? NeverScrollableScrollPhysics() : null,
              controller: widget.controller,
              onPageChanged: (page) {
                if (MediaQuery.of(context).viewInsets.bottom > 0) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                _page = page;
              },
              children: widget.pages,
            ),
          ),
          _Body(
            controller: widget.controller,
            pages: widget.pages,
            onFinish: widget.onFinish,
            nextLabel: widget.nextLabel,
            finishLabel: widget.finishLabel,
            completed: widget.completed,
            disabled: widget.disabled,
          ),
        ],
      ),
    );
  }
}

class _Body extends AnimatedWidget {
  final List<Widget> pages;
  final Function() onFinish;
  final String finishLabel;
  final String nextLabel;
  final bool disabled;
  final bool completed;
  final PageController controller;

  _Body({
    this.pages,
    this.onFinish,
    this.finishLabel,
    this.nextLabel,
    this.disabled,
    this.completed,
    this.controller,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: MyTheme.primaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.keyboard_arrow_left,),
            onPressed: _isDisabled || _firstPage ? null : () {
              controller.previousPage(duration: _duration, curve: _curve);
            },
          ),
          if (!_isDisabled)
            MyFlatButton(
              labelText: _buildLabel(),
              color: _lastPage && !_isCompleted ? Colors.black54 : Colors.white,
              onPressed: _lastPage && !_isCompleted ? null : _buildNextPage,
            ),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.keyboard_arrow_right,),
            onPressed: _isDisabled || _lastPage ? null : () {
              controller.nextPage(duration: _duration, curve: _curve);
            },
          ),
        ],
      ),
    );
  }

  bool get _firstPage {
    return _page == 0;
  }

  bool get _lastPage {
    if (pages.length < 2) {
      return true;
    }
    return _page == pages.length - 1;
  }

  bool get _isDisabled => disabled ?? false;
  bool get _isCompleted => completed ?? true;

  String _buildLabel() {
    if(_lastPage && _isCompleted) {
      return (finishLabel ?? 'Concluir');
    }

    return (nextLabel ?? 'Continuar');
  }

  void _buildNextPage() {
    if (_lastPage && _isCompleted) {
      if (onFinish != null) {
        onFinish();
      }
    } else {
      controller.nextPage(duration: _duration, curve: _curve);
    }
  }
}