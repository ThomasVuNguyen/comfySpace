import 'package:flutter/material.dart';
import 'package:v2_1/chat_ui/chat_ui.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/sendEmail.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/userIdentifier.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:webview_flutter/webview_flutter.dart';


class lessonPage extends StatefulWidget {
  const lessonPage({super.key, required this.lesson});
  final comfy_lesson lesson;

  @override
  State<lessonPage> createState() => _lessonPageState();
}

class _lessonPageState extends State<lessonPage> {
  
  var controller = WebViewController();
  
  @override
  void initState() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onPageFinished: (String){
          controller.runJavaScript(
              "document.querySelector('header').style.display ='none'; document.querySelector('footer').style.display ='none';");
        }
      ),

    )
    ..loadRequest(Uri.parse(widget.lesson.url!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller,),
            Positioned(
              bottom: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: clickable(icon: Icons.comment, onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          chatPage(
                              questions: {
                                'comment': ['Thank you for reading "${widget.lesson.title}"', 'Write your comment down below!']
                              },
                              answers: {'user': getUserID(), 'lesson_title': '${widget.lesson.title}'},
                              title: 'Sending a comment', pageName: 'lesson_comment')
                      )
                    );
                  }),
                )
            ),
            Positioned(
                bottom: 0, left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: clickable(icon: Icons.arrow_back, onTap: (){
                    Navigator.pop(context);
                  }),
                )
            ),
          ],
        ),
      )
    );
  }
}
Future<void> send_lesson_comment(BuildContext context, String user, String lesson_title, String comment) async{
  await sendEmailGeneral('$user has commented on $lesson_title: $comment');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('comment posted!')));
  Navigator.pop(context);
}




