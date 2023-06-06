import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WebImage extends StatefulWidget {
  final String imageSrc;
  final double? height;
  final double? width;
  const WebImage({
    super.key,
    required this.imageSrc,
    this.height,
    this.width,
  });

  @override
  State<WebImage> createState() => _WebImageState();
}

class _WebImageState extends State<WebImage> {
  @override
  void initState() {
    super.initState();
    changeToHtml(widget.imageSrc);
  }

  changeToHtml(String src) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      src,
          (int id) => html.ImageElement()..src = src,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: HtmlElementView(
            viewType: widget.imageSrc,
            key: UniqueKey(), // Add a UniqueKey to force the view to rebuild when the size changes
          ),
        )
    );
  }
}