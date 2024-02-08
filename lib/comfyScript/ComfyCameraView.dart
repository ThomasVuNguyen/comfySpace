import 'dart:io';

import 'package:comfyssh_flutter/FileFunction.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import "package:webview_universal/webview_universal.dart";
import 'package:xterm/xterm.dart';

import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';
import 'package:intl/intl.dart';


class ComfyCameraButton extends StatefulWidget {
  const ComfyCameraButton({super.key,
    required this.name,
    required this.hostname, required this.terminal
  });
  final String hostname; final Terminal terminal; final String name;
  @override
  State<ComfyCameraButton> createState() => _ComfyCameraButtonState();
}

class _ComfyCameraButtonState extends State<ComfyCameraButton> {
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss-SSS').format(now);
    SaveImage(formattedDate, pic);
    print('image saved');
    //ShowCapturedWidget(context, pic!);
    
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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(24.0),
              color: Colors.white,
            ),
            child: Screenshot(
              controller: screenshotController,
                child: InAppWebView(
                    initialUrlRequest:
                    URLRequest(url: WebUri('http://${widget.hostname}:8000/')),
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

class AddComfyCameraButton extends StatefulWidget {
  const AddComfyCameraButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyCameraButton> createState() => _AddComfyCameraButtonState();
}

class _AddComfyCameraButtonState extends State<AddComfyCameraButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit()),
      ],
      child: ListTile(
          title: Text('Camera', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName;
            showDialog(context: context, builder: (BuildContext context){
              buttonSizeY = 1;
              buttonSizeX=1;
              buttonPosition=1;
              return ButtonAlertDialog(
                  title: 'Camera Button',
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        comfyTextField(onChanged: (btnName){
                          buttonName = btnName;
                        }, text: 'button name'),
                        const SizedBox(height: 32, width: double.infinity,),
                      ],
                    ),
                  ),
                  actions: [
                    comfyActionButton(
                      onPressed: (){
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, '', 'ComfyCameraButton');
                        Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                        Navigator.pop(context);
                      },
                    ),
                  ]);
            });
          }
      ),
    );
  }
}