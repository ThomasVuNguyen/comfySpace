import 'dart:async';
import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/xterm.dart';
class VirtualKeyboardView extends StatefulWidget {
  const VirtualKeyboardView(this.keyboard, {super.key});
  final VirtualKeyboard keyboard;

  @override
  State<VirtualKeyboardView> createState() => _VirtualKeyboardViewState();
}

class _VirtualKeyboardViewState extends State<VirtualKeyboardView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.keyboard,
      builder: (context, child) => ToggleButtons(
        borderWidth: 2,
        children: [
          Container(height:45, width:(MediaQuery.of(context).size.width-10)/3, child: Center(child: Text('Ctrl', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 21)))),
          Container(width:(MediaQuery.of(context).size.width-10)/3, child: Center(child: Text('Alt', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 21)))),
          Container(width:(MediaQuery.of(context).size.width-10)/3, child: Center(child: Text('Shift', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 21)))),],
        isSelected: [widget.keyboard.ctrl, widget.keyboard.alt, widget.keyboard.shift],
        color: keycolor, //unselected color
        borderColor: bgcolor,
        selectedBorderColor: Colors.black, //selected colors
        selectedColor: Colors.white,
        fillColor: Colors.black,
        onPressed: (index) {
          switch (index) {
            case 0:
              widget.keyboard.ctrl = !widget.keyboard.ctrl;
              break;
            case 1:
              widget.keyboard.alt = !widget.keyboard.alt;
              break;
            case 2:
              widget.keyboard.shift = !widget.keyboard.shift;
              break;
          }
        },
      ),
    );
  }
}

class VirtualKeyboard extends TerminalInputHandler with ChangeNotifier {
  final TerminalInputHandler _inputHandler;
  VirtualKeyboard(this._inputHandler);

  bool _ctrl = false;
  bool get ctrl => _ctrl;

  set ctrl(bool value) {
    if (_ctrl != value) {
      _ctrl = value;
      notifyListeners();
    }
  }

  bool _shift = false;
  bool get shift => _shift;
  set shift(bool value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  bool _alt = false;

  bool get alt => _alt;

  set alt(bool value) {
    if (_alt != value) {
      _alt = value;
      notifyListeners();
    }
  }

  @override
  String? call(TerminalKeyboardEvent event) {
    return _inputHandler.call(event.copyWith(
      ctrl: event.ctrl || _ctrl,
      shift: event.shift || _shift,
      alt: event.alt || _alt,
    ));
  }
}


