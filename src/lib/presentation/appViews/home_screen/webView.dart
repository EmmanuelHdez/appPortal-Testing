import 'package:flutter/material.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/presentation/appViews/home_screen/navigation_controls.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  final String? token;
  final String? nameRoute;
  final String? messagePin;

  const WebViewContainer(
      {Key? key, required this.url, this.token, this.nameRoute, this.messagePin})
      : super(key: key);

  @override
  State<WebViewContainer> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewContainer> {
  late final WebViewController _controller;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  late String nameRoute = '';
  @override
  void initState() {
    super.initState();   

    nameRoute = widget.nameRoute ?? '';
    final String staticUrl = widget.url;
    final String? token = widget.token;
     String portalURL = '${EnvironmentConfig.portalUrl}/';
    String fullUrl =
        token != null ? '$staticUrl/$token?isWebView=true' : staticUrl;

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF6048DE))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Portal is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Portal started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Portal finished loading: $url');     
            print("These is message pin");
            print(widget.messagePin);
            if (nameRoute.startsWith(AppRoutes.formsScreenPage) && widget.messagePin!=null) {
              _pinDialog(widget.messagePin);
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
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
            if (nameRoute.startsWith(AppRoutes.formsScreenPage) &&
                    change.url!.startsWith(portalURL) ||
                change.url!.startsWith(EnvironmentConfig.authenticatorAppUrl)) {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainScreen(
                          index: 2,
                        )),
                (route) => false,
              );
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(fullUrl));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

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

  @override
  Widget build(BuildContext context) {    
    return WillPopScope(      
      onWillPop: () async {
        return await _onBackPressed();
      },
      child: Scaffold(
        
          appBar: AppBar(
            title: const Text('PUK Patient Portal App'),
            actions: <Widget>[
              NavigationControls(webViewController: _controller),
            ],
          ),
          body: WebViewWidget(
            controller: _controller,
          )),
    );
  }

  void _pinDialog(String? message) async {
    return (      
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text(
                'PIN Required',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700, // Semibold
                    color: Color(0xFF2A3786)),
              ),
            ),
            content: Text(
              message.toString(),
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500, // Semibold
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Ok'),
              ),             
            ],
          ),
        ));
  }



  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text(
                'Confirmation',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700, // Semibold
                    color: Color(0xFF2A3786)),
              ),
            ),
            content: Text(
              'Do you wish to return to the companion app? ${nameRoute.startsWith(AppRoutes.formsScreenPage) ? 'Your progress will be saved.' : ''}',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500, // Semibold
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No, Stay'),
              ),
              TextButton(
                onPressed: () => {
                  if (nameRoute.startsWith(AppRoutes.formsScreenPage))
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen(
                                  index: 2,
                                )),
                        (route) => false,
                      )
                    }
                  else
                    {Navigator.of(context).pop(true)}
                },
                child: const Text('Yes, Leave'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
