import 'package:flutter/material.dart';
import 'package:src/config/config.dart';
import 'package:src/presentation/appViews/home_screen/navigation_controls.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/shared/user_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainerLogin extends StatefulWidget {
  final String url;

  const WebViewContainerLogin({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewContainerLogin> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewContainerLogin> {
  late final WebViewController _controller;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  final UserPreferences userInfo = UserPreferences(); 

  @override
  void initState() {
    super.initState();

    final String redirectURL = EnvironmentConfig.aadb2cRedirectUri;
    final String logoutRedirectURL = EnvironmentConfig.aadb2cLogoutRedirectUri;
    final String staticUrl = widget.url;
    // To determine if the fingerprint print shows

    

    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF6048DE))
      ..loadRequest(Uri.parse(staticUrl))
      ..addJavaScriptChannel("channelWebView",
          onMessageReceived: (JavaScriptMessage message) {
          print(message.message);
      })
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('Azure is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          debugPrint('Azure started loading: $url');
        },
        onPageFinished: (String url) {         
          debugPrint('Azure finished loading: $url');           
          if (url.startsWith(logoutRedirectURL)) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              }
            });
          } else {
            _injectJavascript(_controller);
          }
          if (url.startsWith('$redirectURL?code')) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context, url);
              }
            });
          } else {
            _injectJavascript(_controller);
          }
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

  _injectJavascript(
      WebViewController controller ) async {
        final compatibleFingerprint = await userInfo.getFingerprintCompatible();
        final fingerprintNoFirstLogin = await userInfo.getFingerprintFirstLogin();
        final fingerprintEnabled = await userInfo.getFingerprintEnabled();


    await controller.runJavaScript('''



      
      if(!($compatibleFingerprint) && $fingerprintEnabled) {
        let newDivCompatible = document.createElement("div");
        newDivCompatible.id = "compatibleFingerprint";
        newDivCompatible.style.display = "none";
        document.body.appendChild(newDivCompatible);
      }

      if(!($fingerprintNoFirstLogin)) {
        let newDivFirstLogin = document.createElement("div");
        newDivFirstLogin.id = "fingerprintNoFirstLogin";
        newDivFirstLogin.style.display = "none";
        document.body.appendChild(newDivFirstLogin);
      }

  ''');
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

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PUK Patient Portal App'),
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
