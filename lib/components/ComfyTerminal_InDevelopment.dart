import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class ComfyTerminal extends StatefulWidget {
  const ComfyTerminal({super.key, required this.terminal});
  final Terminal terminal;
  @override
  State<ComfyTerminal> createState() => _ComfyTerminalState();
}

class _ComfyTerminalState extends State<ComfyTerminal> {
  @override
  void initState(){
    //widget.terminal.write("boob");
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //decoration: BoxDecoration( border: Border.all(color: keyGreen, width: 5), borderRadius: BorderRadius.circular(0.0),),
        height: 120,
        child: TerminalView(
            widget.terminal, readOnly: true, padding: const EdgeInsets.all(10.0),
            textStyle: const TerminalStyle(
              fontSize: 18.0,
              fontFamily: 'poppins',
            ),
            theme: TerminalTheme(
              cursor: Theme.of(context).colorScheme.onSecondaryContainer,
              selection: Colors.black,
              foreground: Colors.black,
              background: Theme.of(context).colorScheme.onSecondaryContainer,
              white: Colors.white, red: Colors.red, green: Colors.green, yellow: Colors.yellow, blue: Colors.blue,
              magenta: Colors.white, cyan: Colors.cyan, brightBlack: Colors.black38, brightBlue: Colors.blue, brightRed: Colors.redAccent,
              brightGreen: Colors.greenAccent, brightCyan: Colors.cyanAccent, brightMagenta: Colors.purpleAccent, brightWhite: Colors.white30,
              brightYellow: Colors.yellowAccent, searchHitBackground: Colors.white30, searchHitBackgroundCurrent: Colors.white30, searchHitForeground: Colors.black, black: Colors.black38,
            )
        ));
  }
}
