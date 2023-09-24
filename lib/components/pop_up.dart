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
      title: showTitle? Center(child: Text("New Space"),) :null,
      titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 24.0, color: textcolor),
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
          color: Colors.teal,
          child: Text("Done", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
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
      titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 24.0, color: textcolor),
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
                  deleteSpace('comfySpace.db', widget.spaceName);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                  Future.delayed(const Duration(milliseconds: 100), (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                    });
                  });
                  Navigator.pop(context);
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
              child: Text("Done", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
            ),
          ],
        )
      ],

    );
  }
}

class ButtonAlertDialog extends StatelessWidget {
  const ButtonAlertDialog({super.key, required this.title, required this.content, required this.actions});
  final String title; final Widget content; final List <Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: const EdgeInsets.all(20.0),
      title: Text(title), content: content, actions: actions
    );
  }
}

class comfyTextField extends StatelessWidget {
  const comfyTextField({super.key, required this.text, required this.onChanged, this.keyboardType, this.inputFormatters});
  final void Function(String) onChanged;  final String text; final TextInputType? keyboardType; final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const comfyActionButton({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.teal,
      child: Text("Done", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
    );
  }
}


