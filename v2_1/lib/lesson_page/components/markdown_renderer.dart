import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../home_screen/comfy_user_information_function/lesson_function.dart';
import '../../universal_widget/random_widget_loading.dart';

class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lessonMarkdownRender(path),
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return randomLoadingWidget();
          }
          else{
            return Expanded(
              child: MarkdownBody(
                shrinkWrap: true,

                data: snapshot.data!,
              ),
            );
          }
        }
    );
  }
}