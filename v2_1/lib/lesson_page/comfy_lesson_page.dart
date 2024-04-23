import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';
import 'package:v2_1/lesson_page/components/like_button.dart';
import 'package:v2_1/universal_widget/buttons.dart';

import '../universal_widget/random_widget_loading.dart';
import 'components/markdown_renderer.dart';

class ComfyLessonPage extends StatefulWidget {
  const ComfyLessonPage({super.key, required this.lesson});
  final comfy_lesson lesson;

  @override
  State<ComfyLessonPage> createState() => _ComfyLessonPageState();
}

class _ComfyLessonPageState extends State<ComfyLessonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title!)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.lesson.description!),
              const Gap(16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 2/1,
                  child: Animate(
                    effects: const [FadeEffect(), ScaleEffect()],
                    child: Image.network(
                      widget.lesson.img!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress){
                        if(loadingProgress == null){
                          return child;
                        }else{
                          return const randomLoadingWidget();
                        }
                      },
                      errorBuilder: (context, object, stack){
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
              ),
              Gap(16),
              Text(widget.lesson.author!),
              Gap(16),
              Flexible(
                  fit: FlexFit.loose,
                  flex: 0,
                  child: MarkdownRenderer(path: widget.lesson.content!)),
              Gap(20),
              likeButton(lesson: widget.lesson)
            ],
          ),
        ),
      ),
    );
  }
}



