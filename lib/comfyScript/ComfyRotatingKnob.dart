import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knob_widget/knob_widget.dart';

class ComfyRotatingKnob extends StatefulWidget {
  const ComfyRotatingKnob({super.key});

  @override
  State<ComfyRotatingKnob> createState() => _ComfyRotatingKnobState();
}

class _ComfyRotatingKnobState extends State<ComfyRotatingKnob> {
  final double _minimum = 10; final double _maximum = 40;
  late  KnobController  _controller; late double _KnobValue;

  void ValueChangedListener(double value){
    if(mounted){
      setState(() {
        _KnobValue = value;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _KnobValue = _minimum;
    _controller = KnobController(
      initial: _KnobValue,
      maximum: _maximum,
      minimum: _minimum,
      startAngle: 0,
      endAngle: 180
    );
    _controller.addOnValueChangedListener(ValueChangedListener);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30,),
        Container(
          child: Knob(
            controller: _controller,
            width: 200, height: 200,
            style: KnobStyle(
              labelStyle: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color:Colors.white, ),
              tickOffset: 5,
              labelOffset: 10,
              minorTicksPerInterval: 5
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose(){
    super.dispose();
    _controller.removeOnValueChangedListener(ValueChangedListener);
  }
}
