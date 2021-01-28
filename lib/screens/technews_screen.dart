import 'package:flutter/material.dart';

import 'x_news_screen.dart';

class TechnewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return XNewsScreen(
      newsType: '/technews',
      tag: '/technews',
    );
  }
}
