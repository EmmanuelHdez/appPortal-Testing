import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'navigation_controls.dart';

class WebViewContainer extends StatefulWidget {
  final String url;

  const WebViewContainer({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewContainer> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewContainer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PUK Patient Portal App'),
        actions: [
          NavigationControls(controller: _controller),
        ],
      ),
      body: WebViewLoading(url: widget.url, controller: _controller),
    );
  }
}

class WebViewLoading extends StatefulWidget {
  final String url;
  final Completer<WebViewController> controller;

  const WebViewLoading({
    Key? key,
    required this.url,
    required this.controller,
  }) : super(key: key);

  @override
  State<WebViewLoading> createState() => _WebViewLoadingState();
}

class _WebViewLoadingState extends State<WebViewLoading> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.url,
          onWebViewCreated: (webViewController) {
            widget.controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
