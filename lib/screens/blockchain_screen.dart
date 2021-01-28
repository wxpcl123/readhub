import 'package:flutter/material.dart';

import 'x_news_screen.dart';

class BlockchainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return XNewsScreen(
      newsType: '/blockchain',
      tag: '/blockchain',
    );
  }
}
