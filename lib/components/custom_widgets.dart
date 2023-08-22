import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../function.dart';
import '../main.dart';


class spaceTile extends StatefulWidget {
  const spaceTile({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<spaceTile> createState() => _spaceTileState();
}

class _spaceTileState extends State<spaceTile> {
  late String spaceNameHolder;
  late String hostNameHolder;
  late String userNameHolder;
  late String passwordHolder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: textcolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),topRight: Radius.circular(0.0),bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(0.0),
              )
          ),
          height: 128, width: 106,
          child: IconButton(
              onPressed: () {
              },
              icon: Icon(Icons.add, size: 50,)
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width-40-106, height: 128,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.blue,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(10,10),
              )]
          ),
          child: ListTile(contentPadding: const EdgeInsets.only(top:0.0, bottom: 0.0),
              trailing: Container( width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.arrow_forward_ios, color: textcolor,size: 25,),
                  ],
                ),
              ),
              onLongPress: () {
            //spaceNameHolder = '';
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Edit Space"),
                  content: Column(
                    children: [
                      TextField(
                          onChanged: (text1){
                            spaceNameHolder = text1;},
                          decoration: const InputDecoration(hintText: "space"), textInputAction: TextInputAction.next),
                      TextField(
                        onChanged: (hostname){
                          hostNameHolder = hostname;},
                        decoration: const InputDecoration(hintText: "hostname"), textInputAction: TextInputAction.next,),
                      TextField(
                        onChanged: (username){
                          userNameHolder = username;
                        }, decoration: const InputDecoration(hintText: "username"), textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        onChanged: (password){
                          passwordHolder = password;
                        }, decoration: const InputDecoration(hintText: "password"), textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: (){
                      updateAndroidMetaData('comfySpace.db');
                    }, child: const Text("METADATA")),
                    TextButton(onPressed: (){
                      deleteDB('comfySpace.db');
                    }, child: Text("Wipe")),
                    TextButton(onPressed: (){
                      deleteSpace('comfySpace.db', widget.spaceName);
                      Navigator.pop(context);
                      setState(() {});
                    }, child: Text("Delete")),
                    TextButton(onPressed: (){
                      editSpace('comfySpace.db', widget.spaceName, spaceNameHolder, hostNameHolder, userNameHolder, passwordHolder);
                      Navigator.pop(context);
                      setState(() {
                        print(widget.spaceName);
                        print(spaceNameHolder);
                      });
                    }, child: const Text("Rename")),
                  ],
                );
              });
              },
              onTap: () async {
                spaceLaunch = widget.spaceName;
                var spaceInfo = await hostInfoRenderer('comfySpace.db', spaceLaunch);
                String spaceHost = spaceInfo['host'].toString();
                String spaceUser = spaceInfo['user'].toString();
                String spacePass = spaceInfo['password'].toString();
                print(spacePass);
                hostname = spaceHost; username = spaceUser; password = spacePass;
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const spacePage()),);
              },
              shape: const RoundedRectangleBorder(side: BorderSide(width: 2, color:textcolor) , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0),topRight: Radius.circular(8.0),bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(8.0),)),
              title: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 23, bottom: 23),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.spaceName, style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold,  fontSize: 20)),
                    Text("${widget.spaceName} @ ${widget.spaceName}", style: GoogleFonts.poppins(color: textcolor, fontSize: 16)),
                  ],
                ),
              )
          ),

        )
      ],
    );
  }
}
