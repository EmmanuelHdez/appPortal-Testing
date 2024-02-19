import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:src/config/config.dart';
import 'package:src/presentation/appViews/home_screen/navigation_controls.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewAuthenticator extends StatefulWidget {
  final email;
  final passw;

  const WebViewAuthenticator(
      {Key? key, required this.email, required this.passw})
      : super(key: key);

  @override
  State<WebViewAuthenticator> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewAuthenticator> {
  late WebViewController _controller;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  String? message;

  @override
  void initState() {
    super.initState();

    final String redirectSucessURL =
        "${EnvironmentConfig.portalUrl}/auth/success";
    final String staticUrl =
        '${EnvironmentConfig.authenticatorAppUrl}/loginstart/089656512';
    final String email = widget.email;
    final String passw = widget.passw;

    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF6048DE))
      ..loadRequest(Uri.parse(staticUrl))
      ..addJavaScriptChannel("channelWebView",
          onMessageReceived: (JavaScriptMessage message) {
        setMessage(message.message);
      })
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          if (url.startsWith(staticUrl)) {
            _injectJavascriptAutoLogin(_controller, email, passw);
          }
          if (url.startsWith(redirectSucessURL) ||
              url.startsWith(
                  'https://pukauth-dev.herokuapp.com/auth/success') ||
              url.startsWith(
                  "https://devportal.psychiatry-uk.com/auth/success")) {            
            if (mounted) {
              Navigator.pop(context, url);
            }
          }
        },
        onUrlChange: (UrlChange change) {
          debugPrint('url change to ${change.url}');
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('''
            Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            debugPrint('blocking navigation to ${request.url}');
            return NavigationDecision.prevent;
          }
          debugPrint('allowing navigation to ${request.url}');
          return NavigationDecision.navigate;
        },
      ))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    _controller = controller;
  }

  void disposeWebView() {
    print("=====CLEARING CACHE========");
    _controller.clearCache();
    cookieManager.clearCookies();
    _controller.runJavaScript(
        'document.open("text/html","replace");document.write("");document.close();');
  }

  @override
  void dispose() {
    super.dispose();
    disposeWebView();
    print("=====CLEAR CAHCHE=====");
  }

  setMessage(String javascriptMessage) {
    if (mounted) {
      setState(() {
        message = javascriptMessage;
      });
    }
  }

  _injectJavascriptAutoLogin(
      WebViewController controller, String email, String passw) async {
    controller.runJavaScript('''
        var overlay = document.createElement("div");
        overlay.id = "overlay";
        overlay.style.display = "block";
        overlay.style.position = "fixed";
        overlay.style.top = "0";
        overlay.style.left = "0";
        overlay.style.width = "100%";
        overlay.style.height = "100%";
        overlay.style.backgroundColor = "#fff";
        overlay.style.zIndex = "999";

        var img = document.createElement("img");
        img.src = "https://bpb-us-w2.wpmucdn.com/sites.sienaheights.edu/dist/c/2/files/2022/10/MicrosoftAuthenticator_App_NoBackground_small-3.png";
        img.alt = "Authenticator Loading App";
        img.style.display = "block";
        img.style.margin = "auto";
        img.style.width = "140px"; 
        img.style.position = "absolute";
        img.style.top = "50%";
        img.style.left = "50%";
        img.style.transform = "translate(-50%, -50%)";
        overlay.appendChild(img);
        document.body.appendChild(overlay);
        document.getElementsByName("email")[0].value = "$email";
        document.getElementsByName("passw")[0].value = "$passw";

        var sendButton = document.getElementById("loginButton");  

        if (sendButton) {
            sendButton.click();
        }

  ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PUK Authenticator App'),
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
        ],
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
