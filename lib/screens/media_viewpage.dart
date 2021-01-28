import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MediaViewPage extends StatefulWidget {
  final String url;
  final String title;

  const MediaViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _MediaViewPageState createState() => _MediaViewPageState();
}

class _MediaViewPageState extends State<MediaViewPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Column(
        children: [
          if (isLoading) LinearProgressIndicator(minHeight: 1.5),
          Expanded(
            child: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _controller.complete(controller);
              },
              onPageStarted: (url) {
                print('LOGV: start loading web from $url');
              },
              onPageFinished: (url) {
                print('LOGV: finish loaded web from $url');
                setState(() {
                  isLoading = false;
                });
              },
              onWebResourceError: (error) {
                print(
                    'LOGV: ErrorCode:${error.errorCode}\tErrorDesc:${error.description}');
              },
              // 拦截器
              navigationDelegate: (NavigationRequest request) {
                String url = request.url;
                if (url.startsWith('http:') || url.startsWith('https:'))
                  return NavigationDecision.navigate;
                return NavigationDecision.prevent;
              },
            ),
          ),
        ],
      ),
    );
  }
}
