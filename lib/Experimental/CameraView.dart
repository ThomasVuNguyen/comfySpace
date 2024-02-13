import 'package:comfyssh_flutter/comfyScript/ComfyCameraView.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:xterm/xterm.dart';

class CameraViewVideo extends StatefulWidget {
  const CameraViewVideo({super.key});

  @override
  State<CameraViewVideo> createState() => _CameraViewVideoState();
}

class _CameraViewVideoState extends State<CameraViewVideo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: IOWebSocketChannel.connect('ws://rover.local:8000/stream.mjpg').stream,
        builder: (context, snapshot){
          print(snapshot.data.toString());
          if(snapshot.hasData){
            return RepaintBoundary(child: Image.memory(snapshot.data, width: 500, height: 500,gaplessPlayback: true,));
          }
          else{
            return Text('loading');
          }
        }
    );
  }
}

class CameraAttempt2 extends StatefulWidget {

  const CameraAttempt2({super.key});

  @override
  State<CameraAttempt2> createState() => _CameraAttempt2State();
}

class _CameraAttempt2State extends State<CameraAttempt2> {
  late bool isRecording;
  @override
  void initState(){
    super.initState();
    isRecording = false;
  }
  void Record(){
    if(isRecording !=true){
      isRecording = true;
    }
    else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Column(
        children: [
          ComfyCameraButton(name: 'comfy', hostname: '10.0.0.81', username: 'travel', password: 'travel', terminal: Terminal()),
          TextButton(onPressed: (){
            Record();
          }, child: Container(
            color: (isRecording == true)? Colors.red :Colors.blue,
              child: Text('record')))
        ],
      ),
    );
  }
}

class ExperimentalCameraStream extends StatelessWidget {
  const ExperimentalCameraStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Mjpeg(stream: 'http://rover.local:8000/stream.mjpg', isLive: true,);
  }
}

class VideoPlayerStream extends StatelessWidget {
  const VideoPlayerStream({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
