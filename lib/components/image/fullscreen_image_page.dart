import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageArguments {
  final Key key;
  final String tag;
  final ImageProvider imageProvider;
  final List<Widget> actions;

  FullScreenImageArguments({this.key, this.tag, this.imageProvider, this.actions,});
}

class FullScreenImagePage extends StatelessWidget {
  static const routeName = '/fullscreen';

  final String tag;
  final ImageProvider imageProvider;
  final List<Widget> actions;

  FullScreenImagePage({
    Key key,
    @required this.imageProvider,
    this.actions,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: actions,
      ),
      body: _buildImage()
    );
  }

  _buildImage() {
    return PhotoView(
      imageProvider: imageProvider,
      gaplessPlayback: true,
      heroAttributes: tag != null ? PhotoViewHeroAttributes(tag: tag) : null,
    );
  }
}

class FullScreenGalleryPage extends StatelessWidget {
  final String tag;
  final List<String> items;
  final List<Widget> actions;
  final PageController controller;

  FullScreenGalleryPage({
    Key key,
    @required this.items,
    this.actions,
    this.tag,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: actions,
      ),
      body: PhotoViewGallery.builder(
        builder: _buildItem,
        itemCount: items.length,
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {

    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(items[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
//      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}