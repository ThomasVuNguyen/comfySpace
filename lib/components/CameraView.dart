import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:comfyssh_flutter/main.dart';
class CameraView extends StatefulWidget {
  const CameraView({super.key, required this.camera});
  final CameraDescription camera;
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  double CollapsedWidth = 20;
  double ExpandedWidth = 100;
  double width = 20;
  @override
  void initState(){
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_){
      if (!mounted){
        return;
      }
      setState(() {});
    }).catchError((Object e){
      if (e is CameraException){
        switch (e.code){
          case 'CameraAccessDenied':
            print("camera access denied");
            break;
          default:
            print("default camera error");
        }
      }
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized){
      return Container(height: 20,child: Text("camera not initialized"),);
    }
    else{
      return GestureDetector(
        onTap: (){
          setState(() {
            if (width==CollapsedWidth){
              width = ExpandedWidth;
            }
            else{
              width = CollapsedWidth;
            }
          });
        },
        child: Center(
          child: AnimatedContainer(
            color: Colors.red,
            duration: Duration(milliseconds: 100),
            width: width,
            child: Container(height: 200, child: CameraPreview(controller)),
          ),
        ),
      );
    }
  }
}
