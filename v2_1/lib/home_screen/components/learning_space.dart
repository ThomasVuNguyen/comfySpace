import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';
import 'package:v2_1/lesson_page/comfy_lesson_page.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

class learning_space extends StatelessWidget {
  const learning_space({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1, child: Scaffold(
      appBar: TabBar(
        tabs: [
          Text(''),
          //Text('Projects'),
        ],
      ),
        body:
        TabBarView(
          clipBehavior: Clip.none,
            children: [
          learning_tab(),
          //community_project_tab()
        ])

            ));
  }
}

class learning_card extends StatelessWidget {
  const learning_card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        height: 90,
        child: ListTile(
          leading: Image.network('https://images.unsplash.com/photo-1631553127988-36343ac5bb0c?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          title: Text('The brain', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
          subtitle: Text('The tiny computer that controls it all', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
      ),
    );
  }
}

class learning_tab extends StatelessWidget {
  const learning_tab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllLessonInformation(),
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const randomLoadingWidget();
          }
          else{
            List<comfy_lesson>? comfyLessonList = snapshot.data;
            return ListView.builder(
              itemCount: comfyLessonList?.length,
                itemBuilder: (context, index){
                  return lesson_card(lesson: comfyLessonList![index]);
                });
            return Center(child: Text(snapshot.data!.length.toString()),);
          }
        }
    );

  }
}

class community_project_tab extends StatelessWidget {
  const community_project_tab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('community')
        ],
      ),
    );
  }
}

class lesson_card extends StatelessWidget {
  const lesson_card({super.key, required this.lesson});
  final comfy_lesson lesson;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant
              )
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(11), topLeft: Radius.circular(11)),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                          aspectRatio: 2/1,
                        child: Image.network(
                          lesson.img!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress){
                            if(loadingProgress == null){
                              return child;
                            }else{
                              return randomLoadingWidget();
                            }
                          },
                          errorBuilder: (context, object, stack){
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                              lesson.title!,
                            speed: const Duration(milliseconds: 100),
                            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          )
                        ],
                      )
                      //Text(lesson.title!, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),),
                    ),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ComfyLessonPage(lesson: lesson)));
                    }, icon: Icon(Icons.arrow_forward))
                  ],
                ),

              ],
            )
          ),
        ),
      ),
    );
  }
}
