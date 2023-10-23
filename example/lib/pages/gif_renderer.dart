import 'dart:html';
import 'package:flutter/material.dart';

import '../shims/dart_ui.dart' as ui;

class GifRenderer extends StatelessWidget {
  String src;
  int? width, height;
  GifRenderer({
    this.src =
        'https://itap-uploads.s3.ap-south-1.amazonaws.com/2023/09/Shameless/hls/master.m3u8',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
      "Gif Renderer",
      (int viewId) {
        VideoElement element = VideoElement()
          ..id = 'shakaVideoPlayer'
          ..src = src
          ..autoplay = true
          ..preload = 'auto'
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%';
        element.setAttribute('playsinline', true);
        return element;
      },
    );

    return Container(
      height: double.tryParse(height.toString()),
      width: double.tryParse(width.toString()),
      child: HtmlElementView(
        viewType: "Gif Renderer",
      ),
    );
  }
}
