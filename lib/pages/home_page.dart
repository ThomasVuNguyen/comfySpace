import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';

import '../comfyssh/comfyssh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoryCheck();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'xterm.dart demo',
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}  //MyApp, wraps the main home page