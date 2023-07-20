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
      home: Welcome(),
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
            Container(width: double.infinity, height: 90, color: bgcolor,),
            Container(
              //height: 100,
              child: Center(child: Image.asset('assets/codingguy.png', height: 239.0,)),
              width: double.infinity,
              color: bgcolor,
            ),
            Container(height: 35, color: bgcolor,),
            SizedBox(width: double.infinity, height: 100,
              child: InkWell(
                onLongPress: (){
                  clearData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const HomePage()),
                  );
                },
                onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const HomePage()),
                );
                reAssign();
              }, child: Image.asset('assets/play.png', width: 100,color: accentcolor,),

              ),
            ),Container(height: 35, color: bgcolor,),
            Container(color: bgcolor,child: Text("Press to code comfortably...", style: GoogleFonts.poppins(color: textcolor,  fontSize: 24)),),
            Container(height: 20, color: bgcolor,),
            Container(color: bgcolor,child: Text("*long press to wipe all data if error encountered", style: GoogleFonts.poppins(color: textcolor,  fontSize: 12)),),
          ],
        ),
      ),
    );
  }
}