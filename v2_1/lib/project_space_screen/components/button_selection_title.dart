import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';
import 'package:webview_flutter/webview_flutter.dart';

class buttonSelectionTitle extends StatelessWidget {
  const buttonSelectionTitle(
      {super.key, required this.titleText, this.url = ''});
  final String titleText;
  final String url;

  void showInformation(
    String url,
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          var controller = WebViewController();

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
            ..loadRequest(Uri.parse(url));
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Dialog(
                child: WebViewWidget(
              controller: controller,
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titleText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        (url == '')
            ? const Gap(0)
            : IconButton(
                onPressed: () {
                  showInformation(url, context);
                },
                icon: const Icon(
                  Icons.question_mark,
                  size: 15,
                ))
      ],
    );
  }
}
