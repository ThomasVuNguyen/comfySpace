import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';

import '../components/pop_up.dart';
import '../function.dart';

class ComfyButton extends StatefulWidget {
  const ComfyButton({super.key, required this.buttonName, required this.id, required this.spaceName, required this.command, required this.buttonType, required this.hostname, required this.username, required this.password, required this.terminal});
  final String buttonName; final int id; final String spaceName; final String buttonType; final String command;
  final String hostname; final String username; final String password; final Terminal terminal;
  @override
  State<ComfyButton> createState() => _ComfyButtonState();
}

class _ComfyButtonState extends State<ComfyButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
    ],
      child: GestureDetector(
          onLongPress: (){
            showDialog(context: context, builder: (BuildContext context){
              print(widget.id);
              return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                contentPadding: const EdgeInsets.all(8.0),
                title: Text('Delete Button'),
                actions: [
                  CancelButtonPrompt(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  deleteButtonPrompt(
                    onPressed: () {
                      deleteButton('comfySpace.db', widget.spaceName, widget.buttonName, widget.id);
                      Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
          },
          child: ButtonSorting(widget.id, widget.buttonName, widget.buttonType, widget.spaceName, widget.hostname, widget.username, widget.password, widget.command, widget.terminal)
  ,
    ));}
}
