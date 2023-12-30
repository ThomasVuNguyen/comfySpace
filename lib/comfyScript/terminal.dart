import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/ui.dart';
import 'package:xterm/xterm.dart';

class ComfyTerminal extends StatefulWidget {
  const ComfyTerminal({super.key, required this.terminal});
  final Terminal terminal;
  @override
  State<ComfyTerminal> createState() => _ComfyTerminalState();
}

class _ComfyTerminalState extends State<ComfyTerminal> {
  Color BackgroundColor = Color(0xffEDF0F7);
  Color TextColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: BackgroundColor,
          //Theme.of(context).colorScheme.onSecondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //collapsedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                //backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                initiallyExpanded: true,
                title: Text("Terminal", style: GoogleFonts.inter(color: TextColor),),
                onExpansionChanged: (bool expanded){
                },
                children: [
                  SizedBox(
                      height: 120,
                      child: TerminalView(
                          widget.terminal, readOnly: true, padding: const EdgeInsets.all(16.0),
                          textStyle: const TerminalStyle(
                            fontSize: 14.0,
                            fontFamily: 'inter',
                          ),
                          theme: TerminalTheme(
                            cursor: BackgroundColor,
                            //Theme.of(context).colorScheme.onSecondaryContainer,
                            selection: Colors.black,
                            foreground: Colors.black,
                            background: BackgroundColor,
                            //Theme.of(context).colorScheme.onSecondaryContainer,
                            white: Colors.white, red: Colors.red, green: Colors.green, yellow: Colors.yellow, blue: Colors.blue,
                            magenta: Colors.white, cyan: Colors.cyan, brightBlack: Colors.black38, brightBlue: Colors.blue, brightRed: Colors.redAccent,
                            brightGreen: Colors.greenAccent, brightCyan: Colors.cyanAccent, brightMagenta: Colors.purpleAccent, brightWhite: Colors.white30,
                            brightYellow: Colors.yellowAccent, searchHitBackground: Colors.white30, searchHitBackgroundCurrent: Colors.white30, searchHitForeground: Colors.black, black: Colors.black38,
                          )
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}


class ExperimentalComfyTerminal extends StatefulWidget {
  const ExperimentalComfyTerminal({super.key, required this.terminal});
  final Terminal terminal;

  @override
  State<ExperimentalComfyTerminal> createState() => _ExperimentalComfyTerminalState();
}

class _ExperimentalComfyTerminalState extends State<ExperimentalComfyTerminal> {
  double TerminalHeight = 120;
  double MinimumHeight = 0;
  double MaximumHeight = 120;
  void ToggleTerminal(){
    if(TerminalHeight==MinimumHeight){
      TerminalHeight=MaximumHeight;
    }
    else if(TerminalHeight==MaximumHeight){
      TerminalHeight=MinimumHeight;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        //alignment: Alignment.bottomRight,
        children: [
          AnimatedContainer(
              height: TerminalHeight,
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))
              ),
              child: TerminalView(
                  widget.terminal, readOnly: true, padding: const EdgeInsets.all(8),
                  textStyle: const TerminalStyle(
                    fontSize: 16.0,
                    fontFamily: 'poppins',
                  ),
                  theme: TerminalTheme(
                    cursor: (TerminalHeight==0)? Colors.transparent :Theme.of(context).colorScheme.onSecondaryContainer,
                    selection: Colors.black,
                    foreground: Colors.black,
                    background: Theme.of(context).colorScheme.onSecondaryContainer,
                    white: Colors.white, red: Colors.red, green: Colors.green, yellow: Colors.yellow, blue: Colors.blue,
                    magenta: Colors.white, cyan: Colors.cyan, brightBlack: Colors.black38, brightBlue: Colors.blue, brightRed: Colors.redAccent,
                    brightGreen: Colors.greenAccent, brightCyan: Colors.cyanAccent, brightMagenta: Colors.purpleAccent, brightWhite: Colors.white30,
                    brightYellow: Colors.yellowAccent, searchHitBackground: Colors.white30, searchHitBackgroundCurrent: Colors.white30, searchHitForeground: Colors.black, black: Colors.black38,
                  )
              )),
          Container(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            child: IconButton(onPressed: (){
              setState(() {
                ToggleTerminal();
              });
            }, icon: Icon(Icons.hide_image)),),
          Text(widget.terminal.buffer.toString())
        ],
      ),
    );
  }
}
