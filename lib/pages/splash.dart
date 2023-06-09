import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:comfyssh_flutter/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: bgcolor,
        elevation: 0.0,
      ),
      body: Container(
        color: bgcolor,height: double.infinity,
        child: Column( crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: double.infinity, height: 141, color: bgcolor,),
            Container(
              //height: 100,
              child: Center(child: Image.asset('assets/codingguy.png', height: 239.0,)),
              width: double.infinity,
              color: bgcolor,
            ),
            Container(child: Text("Code away your worry", style: GoogleFonts.poppins(color: textcolor,  fontSize: 24)),color: bgcolor,),
            Container(height: 35, color: bgcolor,),
            Container(width: double.infinity, height: 100,
              child: IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const HomePage()),
                );
                reAssign();
              }, icon: Image.asset('assets/play.png', width: 100,), ),
            )
          ],
        ),
      ),
    );
  }
}