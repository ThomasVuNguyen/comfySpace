import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: Uri(path: "https://github.com/flutter")),
      onWebViewCreated: (controller){
        webViewController = controller;
      },
    );
  }
}
