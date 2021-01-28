import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  final VoidCallback onTap;

  const Loading({Key key, this.onTap})
      : assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).accentColor,
      child: Center(
        child: TextButton(
          onPressed: onTap,
          child: Text('加载中, 长时间无响应请刷新'),
        ),
      ),
    );
  }
}
