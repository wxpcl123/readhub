import 'package:flutter/material.dart';

import 'x_news_screen.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return XNewsScreen(
      newsType: '/news',
      tag: '/news',
    );
  }
}
