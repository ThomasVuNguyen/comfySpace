import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

import '../../lesson_page/comfy_lesson_page.dart';

class learning_space extends StatelessWidget {
  const learning_space({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
    return const SingleChildScrollView(
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
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => lessonPage(lesson: lesson)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.network(lesson.imgURL!)),
                Gap(10),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    lesson.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ),

                Gap(10),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                      lesson.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
          ],
        ),
      ),
    );
  }
}
