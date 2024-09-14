import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class comfyShareScreen extends StatefulWidget {
  const comfyShareScreen({super.key});

  @override
  State<comfyShareScreen> createState() => _comfyShareScreenState();
}

class _comfyShareScreenState extends State<comfyShareScreen> {
  @override
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://comfyspace.tech/share'));

  @override
  void initState() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onPageFinished: (String) {
              controller.runJavaScript(
                  "document.querySelector('header').style.display ='none'; document.querySelector('footer').style.display ='none';");
            }),
      )
      ..loadRequest(Uri.parse('https://comfyspace.tech/share'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: WebViewWidget(
        controller: controller,
      ),
    ));
  }
}
