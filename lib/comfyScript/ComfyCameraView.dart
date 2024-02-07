import 'dart:io';

import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import "package:webview_universal/webview_universal.dart";



class ComfyCameraView extends StatefulWidget {
  const ComfyCameraView({super.key});

  @override
  State<ComfyCameraView> createState() => _ComfyCameraViewState();
}

class _ComfyCameraViewState extends State<ComfyCameraView> {
  bool SSHLoaded = true;
  late SSHClient client;
  ScreenshotController screenshotController = ScreenshotController();
  InAppWebViewController? webViewController;
  @override
  void initState(){
    super.initState();
    //initClient();
  }

  @override
  void dispose(){
    super.dispose();
    //closeClient();
  }

  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect('travel.local', 22),
      username: 'travel',
      onPasswordRequest: () => 'travel'
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoaded = true;});
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();
  }

  void RecordVideo(){

  }
  void EndRecording(){

  }
  Future<void> TakePicture() async{
    ScreenshotConfiguration screenshotconfig = ScreenshotConfiguration();

    print('cheese');
    var pic = await webViewController?.takeScreenshot(screenshotConfiguration: screenshotconfig);
    ShowCapturedWidget(context, pic!);
    /*
    screenshotController.capture(delay: Duration(milliseconds: 10)).then((image) async {
      ShowCapturedWidget(context, image!);
      print('cheeze2');
      //final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
      //String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      //String path = '$directory';
/*
      screenshotController.captureAndSave(
      path, //set path where screenshot will be saved
      fileName:fileName
      );*/



    }).catchError((onError) {
      print(onError);
    }); */
  }

  @override
  Widget build(BuildContext context) {
      if (Platform.isAndroid == true || Platform.isIOS == true){
        return GestureDetector(
          onDoubleTap: () async{
            TakePicture();
          },
          child: Container(
            height: 400,
            width: 400,
            color: Colors.white,
            child: Screenshot(
              controller: screenshotController,
                child: InAppWebView(
                    initialUrlRequest:
                    URLRequest(url: WebUri('http://10.0.0.81:8000/stream.mjpg')),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                  },
                ),

            ),
          ),
        );
      }
      else if (Platform.isMacOS){
        return Container(
          child: Text('MacOS not supported, yet'),
        );
      }
      else if(Platform.isWindows){
        return Container(
          child: Text('Windows not supported'),
        );
      }
      else if(Platform.isLinux){
        return Text('Linux not supported');
      }
      else if(kIsWeb == true){
        return Text('Web not supported');
      }
      else{
        return Text('not supported');
      }


  }
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: (capturedImage==null)? Text('none') :Image.memory(capturedImage)),
      ),
    );
  }
}
