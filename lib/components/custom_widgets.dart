import 'dart:async';
import 'package:comfyssh_flutter/legacy/updateRepo.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/xterm.dart';
import '../function.dart';
import '../main.dart';

const double buttonPadding = 8.0;

class comfyAppBar extends StatefulWidget {
  const comfyAppBar({
    super.key, required this.title, this.automaticallyImplyLeading = false, this.IsSpacePage = false,
    this.endDrawer = false,this.titleWidget});
  final String title; final bool automaticallyImplyLeading; final bool IsSpacePage; final bool endDrawer;
  final Widget? titleWidget;
  @override
  State<comfyAppBar> createState() => _comfyAppBarState();
}

class _comfyAppBarState extends State<comfyAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64.0),
      child: AppBar(
          backgroundColor: Color(0xff717D96),
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        actions: [
          Row(
            children: [
              (widget.endDrawer != null)? IconButton(onPressed: (){
                Scaffold.of(context).openEndDrawer();
              }, icon: const Icon(Icons.add)) :const SizedBox(width: 0,),
              const SizedBox(width: 10,),
            ],
          )
        ],
        iconTheme: const IconThemeData(
          //color: textcolor,
        ),
        toolbarHeight: 64,
        titleSpacing: 20,
        title: Row(
          children: <Widget>[
            (widget.IsSpacePage == true)? Container(child: widget.titleWidget,) :Text(widget.title,),
          ],
        ),
        elevation: 0,
      ),
    );
  }
}

class spaceTile extends StatefulWidget {
  const spaceTile({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<spaceTile> createState() => _spaceTileState();
}

class _spaceTileState extends State<spaceTile> {
  late String spaceNameHolder; late String hostNameHolder; late String userNameHolder; late String passwordHolder; bool hostInfoLoaded = false;
  @override
  void initState(){
    super.initState();
    getSpaceInfo(widget.spaceName);
    setState(() {
    });
  }
  void editPrompt(){
    showDialog(context: context, builder: (BuildContext context){
      return EditSpaceDialog(spaceName: widget.spaceName);
    });
  }
  Future<void> getSpaceInfo(String spaceName) async{
    var spaceInfo = await hostInfoRenderer('comfySpace.db', widget.spaceName);
    print(spaceInfo.toString());
    hostNameHolder = spaceInfo['host'].toString();
    userNameHolder = spaceInfo['user'].toString();
    passwordHolder = spaceInfo['password'].toString();
    hostInfoLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width-40,
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(top:16.0, bottom: 16.0, left: 16.0, right: 16.0),
                trailing: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect( borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                          onPressed: (){
                            editPrompt();
                          }, icon: const Icon(Icons.edit_outlined, color: Color(0xffEADDFF),)),
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => spacePage(spaceName: widget.spaceName, hostname: hostNameHolder, username: userNameHolder, password: passwordHolder)),);
                  print("$userNameHolder@$hostNameHolder");
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2,
                      color: Colors.black
                    //Theme.of(context).colorScheme.tertiary
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)), ),
                  title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.spaceName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),),
                      hostInfoLoaded? Text('$userNameHolder @ $hostNameHolder', style: GoogleFonts.poppins(fontSize: 16), ) : const Text('')
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}








