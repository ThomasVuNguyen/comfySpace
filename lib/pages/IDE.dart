import 'package:flutter/material.dart';
import 'package:xterm/ui.dart';
import 'package:xterm/xterm.dart';

class ComfyIDE extends StatefulWidget {
  const ComfyIDE({super.key});

  @override
  State<ComfyIDE> createState() => _ComfyIDEState();
}

class _ComfyIDEState extends State<ComfyIDE> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IDETextEditor(),
          IDEConsole()
        ],
      ),
    );
  }
}

class IDETextEditor extends StatefulWidget {
  const IDETextEditor({super.key});

  @override
  State<IDETextEditor> createState() => _IDETextEditorState();
}

class _IDETextEditorState extends State<IDETextEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton(items: [], onChanged:(object){}),
            IconButton(onPressed: (){
            }, icon: Icon(Icons.save))
          ],
        ),
        Container(
          color: Color(0xffA0ABC0),
          child: TextField(
            style: TextStyle(color: Colors.black),
            cursorColor: Color(0xff34AFF7),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),

      ],
    );
  }
}

class IDEConsole extends StatefulWidget {
  const IDEConsole({super.key});

  @override
  State<IDEConsole> createState() => _IDEConsoleState();
}

class _IDEConsoleState extends State<IDEConsole> {
  @override
  Terminal terminal = Terminal(
    maxLines: 10,
  );
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Color(0xffF134F7),
        child: TerminalView(terminal));
  }
}

Future<void> SnippetListRenderer()  async{

}
Future<void> AddSnippet()  async{

}
Future<void> DeleteSnippet()  async{

}
Future<void> EditSnippet()  async{

}