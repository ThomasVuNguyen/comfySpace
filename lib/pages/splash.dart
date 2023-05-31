import 'package:comfyssh_flutter/function.dart';
import 'package:flutter/material.dart';
import 'package:comfyssh_flutter/pages/home_page.dart';
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoryCheck();
  }
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ComfySSH',
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 79), //create gap
          Image.asset('assets/onboarding-image.png', width:180, height: 168,),
          const SizedBox(height: 79), //create gap
          const SizedBox(height: 21), //create gap
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const HomePage()),
              );
              reAssign();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text('This is my practice app splash screen. Feel free to play around',
                textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }
}

void toHomePage(){

}