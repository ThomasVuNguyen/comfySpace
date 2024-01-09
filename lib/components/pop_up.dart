import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../function.dart';
import '../main.dart';

class NewSpaceDialog extends StatefulWidget {
  const NewSpaceDialog({super.key});

  @override
  State<NewSpaceDialog> createState() => _NewSpaceDialogState();
}

class _NewSpaceDialogState extends State<NewSpaceDialog> {
  bool showTitle = true; bool passwordVisible = true;
  late String spaceNameHolder; late String hostNameHolder; late String usernameHolder; late String passwordHolder;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: const EdgeInsets.all(20.0),
      title: showTitle? const Center(child: Text("New Space"),) :null,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (spaceName){
                spaceNameHolder = spaceName;
              },
              decoration: InputDecoration(
                  hintText: "Space Name", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (hostName){
                hostNameHolder = hostName;
              },
              decoration: InputDecoration(
                  hintText: "Hostname / IP", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (userName){
                usernameHolder = userName;
              },
              decoration: InputDecoration(
                  hintText: "Username", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              obscureText: passwordVisible,
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (password){
                passwordHolder = password;
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible? Icons.visibility: Icons.visibility_off),
                  onPressed: (){
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                  hintText: "Password", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
            onPressed: (){
              createSpace(spaceNameHolder, hostNameHolder, usernameHolder, passwordHolder );
              //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
              Future.delayed(const Duration(milliseconds: 100), (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                });
              });

            },
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          child: Text("Done", style: GoogleFonts.poppins(fontSize: 18, color: Theme.of(context).colorScheme.secondary,)),
            )
      ],

    );
  }
}

class EditSpaceDialog extends StatefulWidget {
  const EditSpaceDialog({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<EditSpaceDialog> createState() => _EditSpaceDialogState();
}

class _EditSpaceDialogState extends State<EditSpaceDialog> {
  bool showTitle = true; bool passwordVisible = true;
  late String spaceNameHolder; late String hostNameHolder; late String usernameHolder; late String passwordHolder;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: const EdgeInsets.all(20.0),
      title: showTitle? const Center(child: Text("Edit Space"),) :null,
      titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 24.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (spaceName){
                spaceNameHolder = spaceName;
              },
              decoration: InputDecoration(
                  hintText: "Space Name", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (hostName){
                hostNameHolder = hostName;
              },
              decoration: InputDecoration(
                  hintText: "hostname / IP", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (userName){
                usernameHolder = userName;
              },
              decoration: InputDecoration(
                  hintText: "username", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
            TextField( //space name
              obscureText: passwordVisible,
              onTap: (){
                setState(() {showTitle = false;});
              },
              onChanged: (password){
                passwordHolder = password;
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible? Icons.visibility: Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  hintText: "password", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
              ),textInputAction: TextInputAction.next,),
            const SizedBox(height: 32, width: double.infinity,),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            MaterialButton(
                onPressed: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return DeleteSpaceConfirmation(spaceName: widget.spaceName);
                  });

                },
              color: Colors.red,
              child: Text("Delete", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
            ),
            MaterialButton(
              onPressed: (){
                editSpace('comfySpace.db', widget.spaceName, spaceNameHolder, hostNameHolder, usernameHolder, passwordHolder);
                Navigator.pop(context);
                //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                Future.delayed(const Duration(milliseconds: 100), (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                  });
                });

                setState(() {
                  print(widget.spaceName);
                  print(spaceNameHolder);
                });

              },
              color: Colors.teal,
              child: Text("Rename", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
            ),
          ],
        )
      ],

    );
  }
}

class ButtonAlertDialog extends StatefulWidget {
  const ButtonAlertDialog({super.key, required this.title, required this.content, required this.actions, this.padding, this.width, this.color});
  final String title; final Widget content; final List <Widget> actions; final double? padding; final double? width; final Color? color;
  @override
  State<ButtonAlertDialog> createState() => _ButtonAlertDialogState();
}

class _ButtonAlertDialogState extends State<ButtonAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.color,
      insetPadding: EdgeInsets.all(10.0),
      scrollable: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: (widget.padding==null)? const EdgeInsets.all(20.0): EdgeInsets.all(widget.padding!),
      title: Text(widget.title), content: SizedBox(
      child: widget.content,
      width: widget.width,
    ), actions: widget.actions
    );
  }
}

class comfyTextField extends StatelessWidget {
  const comfyTextField({super.key, required this.text, required this.onChanged, this.keyboardType, this.inputFormatters});
  final void Function(String) onChanged;  final String text; final TextInputType? keyboardType; final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      onChanged: onChanged,
      keyboardType: keyboardType, inputFormatters: inputFormatters,
      decoration: InputDecoration(
          hintText: text, hintStyle: GoogleFonts.poppins(fontSize: 18.0),
          focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
      ),textInputAction: TextInputAction.next,
    );
  }
}

class comfyActionButton extends StatelessWidget {
  const comfyActionButton({super.key, this.onPressed, this.text = 'Done', this.color = Colors.teal, this.textColor = bgcolor});
  final void Function()? onPressed; final String text; final Color color; final Color textColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      child: Text(text, style: GoogleFonts.poppins(fontSize: 18, color: textColor)),
    );
  }
}

class deleteButtonPrompt extends StatelessWidget {
  const deleteButtonPrompt({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.red,
      child: Text("Yes", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
    );
  }
}

class CancelButtonPrompt extends StatelessWidget {
  const CancelButtonPrompt({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.black,
      child: Text("Cancel", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
    );
  }
}

class DeleteButtonDialog extends StatelessWidget {
  const DeleteButtonDialog({super.key, required this.function});
  final Future<void> function;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: const EdgeInsets.all(20.0),
      title: const Text('Delete Button'),
      actions: [
        comfyActionButton(
          onPressed: () async{
            function;
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

class DeleteSpaceConfirmation extends StatelessWidget {
  const DeleteSpaceConfirmation({super.key, required this.spaceName});
  final String spaceName;
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: const EdgeInsets.all(20.0),
      title: Text('Delete space $spaceName?'),
      actions: [
        MaterialButton(
          color: Colors.teal,
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("No", style: GoogleFonts.poppins(fontSize: 18)),
        ),
        MaterialButton(
        onPressed: (){
          deleteSpace('comfySpace.db', spaceName); //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            Future.delayed(const Duration(milliseconds: 100), (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            });
            Navigator.pop(context);
            },
          color: Colors.red,
          child: Text("Yes", style: GoogleFonts.poppins(fontSize: 18)),
    )
      ],
    );
  }
}




