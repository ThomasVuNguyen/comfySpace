import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2_1/create_new_project/components/experience_picker.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';

import '../../universal_widget/random_widget_loading.dart';
import '../../universal_widget/talking_head.dart';

class pickProjectImage extends StatefulWidget {
  const pickProjectImage({super.key,
    required this.project_name, required this.project_description});
  final String project_name; final String project_description;
  @override
  State<pickProjectImage> createState() => _pickProjectImageState();
}

class _pickProjectImageState extends State<pickProjectImage> {
  @override
  void initState() {
    if (kDebugMode) {
      print('unsplash reload');
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future<List<Photo>> photoSearch = search_image(widget.project_name);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              children: [
                const talkingHead(text: 'Pick an image that suits your project.',),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child:
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      FutureBuilder(
                          future: photoSearch,
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done && snapshot.data !=null){
                              List<String> imgURL = [];
                              List<String> imgAuthor = [];
                              for (int i = 0; i< snapshot.data!.length; i++){
                                imgURL.add(snapshot.data![i].urls.full.toString());
                                imgAuthor.add(snapshot.data![i].user.name);
                              }
                              List<Photo> photoList = snapshot.data!;
                              return ListView.builder(
                                  physics : const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: photoList.length,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                                              border: Border.all(
                                                  color: Theme.of(context).colorScheme.outline
                                              ),
                                              color: Theme.of(context).colorScheme.surface
                                          ),
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                                                  child: Image.network(
                                                      photoList[index].urls.regular.toString(),
                                                      fit: BoxFit.fitWidth
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                                  color: Colors.white,
                                                ),
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'by ',
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                    GestureDetector(
                                                      child: Text(
                                                        photoList[index].user.name,
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.underline),
                                                      ),
                                                      onTap: () async{
                                                        String referral_link = '?utm_source=comfyspace&utm_medium=referral';
                                                        String author_link = photoList[index].user.links.html.toString();
                                                        await launchUrl(Uri.parse(author_link + referral_link));
                                                      },
                                                    ),
                                                    Text(
                                                      ' on ',
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                    GestureDetector(
                                                      child: Text(
                                                        'Unsplash',
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.underline),
                                                      ),
                                                      onTap: () async{
                                                        String referral_link = '?utm_source=comfyspace&utm_medium=referral';
                                                        String unsplash_link = 'https://unsplash.com/';
                                                        await launchUrl(Uri.parse(unsplash_link + referral_link));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*
                                          Positioned(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(11)),
                                                color: Colors.white,
                                              ),
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                (photoList[index].description.toString()==null)? '',
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ),
                                            right: 0,
                                            top: 0,
                                          )*/

                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => experiencePicker(
                                                project_name: widget.project_name,
                                                project_description: widget.project_description,
                                                imgURL: photoList[index].urls.regular.toString(),
                                              ))
                                          );
                                        },
                                      ),
                                    );
                                  }
                              );
                            }
                            else if(snapshot.connectionState == ConnectionState.done && snapshot.data ==null){
                              return Text('null');
                            }
                            else{
                              return const randomLoadingWidget();
                            }
                          }

                      ),

                    ],
                  ),
                ),]
          ),
        ),
      ),
    );
  }
}