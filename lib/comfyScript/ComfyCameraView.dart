import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:comfyssh_flutter/FileFunction.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:xterm/xterm.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';

class ComfyCameraButton extends StatefulWidget {
  const ComfyCameraButton({super.key,
    required this.name,
    required this.hostname, required this.username, required this.password,
    required this.terminal
  });
  final String hostname; final String username; final String password;
  final Terminal terminal; final String name;
  @override
  State<ComfyCameraButton> createState() => _ComfyCameraButtonState();
}

class _ComfyCameraButtonState extends State<ComfyCameraButton> {
  bool SSHLoaded = false;
  late bool isRecording;
  late SSHClient client;
  late String lastVideoName;
  late SSHSession videoSession;
  late SSHSession streamSession;
  ScreenshotController screenshotController = ScreenshotController();
  late InAppWebViewController webViewController;
  bool _streamInitialized = false;
  @override
  void initState(){
    //_streamViewInitialized = false;
    super.initState();
    print('starting camera');
    isRecording = false;
    initClient();

  }
  @override
  void deactivate(){
    super.deactivate();
    //client.close();
    print('closing camera');
    //streamSession.kill(SSHSignal.QUIT);
    //closeClient();
  }
  @override
  void dispose(){
    super.dispose();
    print('closing camera');
    //streamSession.kill(SSHSignal.QUIT);
    closeClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password
    );
    client.run('comfy camera stream');
    setState(() {
      SSHLoaded = true;
    });
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();
    await webViewController.closeAllMediaPresentations();
  }
  Future<void> Record() async {
    if(isRecording !=true){
      print('recording');
      isRecording = true;
      String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      lastVideoName = 'ComfyVideo$timestamp.mp4';
      videoSession = await client.execute('ffmpeg -i http://0.0.0.0:8000/stream.mjpg -c:v copy -c:a aac $lastVideoName');
      print('recoding 2');
    }
    else{
      print('end recording');
      isRecording = false;
      videoSession.kill(SSHSignal.QUIT);
    }
  }
  Future<void> TakePicture() async{
    //await webViewController.reload();
    ScreenshotConfiguration screenshotconfig = ScreenshotConfiguration();
    print('cheese');
    var pic = await webViewController?.takeScreenshot(screenshotConfiguration: screenshotconfig);
    SaveImage(pic);
    print('image saved');

  }

  @override
  Widget build(BuildContext context) {
    if(SSHLoaded == true){
      if (Platform.isAndroid == true || Platform.isIOS == true){
        return GestureDetector(
          onDoubleTap: () async {
            print('doubled');
            await Record();
          },
          onTap: () async{
            TakePicture();
          },
          child: Padding(
            padding: const EdgeInsets.all(buttonPadding),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.white,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: Screenshot(
                  controller: screenshotController,
                  child: InAppWebView(
                    initialUrlRequest:
                    URLRequest(url: WebUri(
                        'http://${widget.hostname}:8000/stream.mjpg'
                      //'https://www.raspberrypi.com/products/raspberry-pi-high-quality-camera/'
                    )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewController = controller;
                      //await client.run('comfy camera stream');
                      print('streaming');
                    },
                    onLoadStop: (InAppWebViewController controller, uri) {

                      if (_streamInitialized == false){
                        //Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                        //controller.reload();
                      }
                      /*
                      else if(_streamInitialized == true && _streamViewInitialized == false) {
                          controller.reload();
                          controller.reload();
                          _streamViewInitialized = true;

                      }
                      */

                    },
                  ),

                ),
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
    else{
      return Text('Loading SSH');
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

  Future<dynamic> ShowCapturedVideo(
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