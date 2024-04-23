import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';

class likeButton extends StatefulWidget {
  const likeButton({super.key, required this.lesson});
  final comfy_lesson lesson;

  @override
  State<likeButton> createState() => _likeButtonState();
}

class _likeButtonState extends State<likeButton> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LikeButton(
        onTap: (liked) async{
          await likeLesson(widget.lesson.docID!);
          return true;
        },
        isLiked: widget.lesson.like,
        size: 30,
        circleColor: CircleColor(
            start: Theme.of(context).colorScheme.secondaryContainer,
          end: Theme.of(context).colorScheme.primaryContainer,
        ),
        likeBuilder: (likeBool){
          return Icon(
            Icons.thumb_up,
            color: likeBool ? Colors.deepPurpleAccent : Colors.grey,
            size: 30,
          );
        },
        likeCount: widget.lesson.numberOfLikes,
        countBuilder: (count, bool isLiked, String text) {
          var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
          Widget result;
          if (count == 0) {
            result = Text(
              "love",
              style: TextStyle(color: color),
            );
          } else
            result = Text(
              text,
              style: TextStyle(color: color),
            );
          return result;
        },
      ),
    );
    return AnimatedContainer(
      width: 100, height: 100,
        duration: const Duration(milliseconds: 100),
      child: IconButton(
        color: (widget.lesson.like == true)? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
        icon: const Icon(Icons.thumb_up),
        onPressed: () async{
          await likeLesson(widget.lesson.docID!);
          setState(() {});
        },
      ),
    );
  }
}
