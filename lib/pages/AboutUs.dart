import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class aboutUs extends StatelessWidget {
  const aboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    print("loading markdown");
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/comfyWeb/buttonGuide.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Center(child: Markdown(data: snapshot.data!));
        }
        else{
          return Center(
            child: Markdown(data: 'hi')
          );
        }
      },

    );
  }
}
