import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../function.dart';

class comfyAppBar extends StatefulWidget {
  const comfyAppBar({super.key, required this.title});
  final String title;
  @override
  State<comfyAppBar> createState() => _comfyAppBarState();
}

class _comfyAppBarState extends State<comfyAppBar> {
  @override
  void initState(){
    super.initState();
  }
  @override dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: textcolor, width:2)),
      title: Row(
        children: <Widget>[
          const SizedBox(width: 0, height: 20, child: DecoratedBox(decoration: BoxDecoration(color: bgcolor,)),),
          Text(widget.title, style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),)
        ],
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: bgcolor,
      ),
      elevation: 0, backgroundColor: bgcolor,
      actionsIconTheme: const IconThemeData(size: 30, color: Colors.black, opacity: 10.0),
      leading: Icon(Icons.add),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(Icons.add, color: Colors.black,),
            onTap: (){
              setState(() {});
              String testHost = checkHostInfo('comfySpace.db').toString();
              print(testHost);
            },
          ),
        ),
        IconButton(onPressed: (){}, icon: Icon(Icons.beach_access_rounded))

      ],
    );

  }
}
