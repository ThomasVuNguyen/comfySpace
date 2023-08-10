//Double Terminal
/*
class Term2 extends StatefulWidget {
  const Term2({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TerminalPage2 createState() => _TerminalPage2();
} //Double Terminal

class _TerminalPage2 extends State<Term2> {
  late final terminal = Terminal(inputHandler: keyboard);
  late final terminal2 = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
  var title = hostname! + username! + password!;
  @override
  void initState() {
    super.initState();
    initTerminal();
  }
  Future<void> initTerminal() async {
    terminal.write('Connecting...\r\n');terminal2.write('Connecting...\r\n');
    final client = SSHClient(
      await SSHSocket.connect(hostname!, port),
      username: username!,
      onPasswordRequest: () => password!,
    );
    final client2 = SSHClient(
      await SSHSocket.connect(hostname!, port),
      username: username!,
      onPasswordRequest: () => password!,
    );

    terminal.write('Connected\r\n');terminal2.write('Connected\r\n');

    final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );
    final session2 = await client2.shell(
      pty: SSHPtyConfig(
        width: terminal2.viewWidth,
        height: terminal2.viewHeight,
      ),
    );
    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);
    terminal2.buffer.clear();
    terminal2.buffer.setCursor(0, 0);

    terminal.onTitleChange = (title) {
      setState(() => this.title = title);
    };
    terminal2.onTitleChange = (title) {
      setState(() => this.title = title);
    };

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };
    terminal2.onResize = (width, height, pixelWidth, pixelHeight) {
      session2.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(utf8.encode(data) as Uint8List);
    };
    terminal2.onOutput = (data) {
      session2.write(utf8.encode(data) as Uint8List);
    };

    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);
    session2.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal2.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);
    session2.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal2.write);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 64,
        shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: bgcolor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //left alignment for texts
          children: [
            Text(nickname!,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 21)),
            Text(distro!,style: GoogleFonts.poppins(color: textcolor, fontSize: 12)),
          ],
        ),
        backgroundColor: bgcolor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back, color: textcolor,))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: TerminalView(terminal),
            ),
            Expanded(
              child: TerminalView(terminal2),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: VirtualKeyboardView(keyboard),
      ),
    );
  }
} //Double Terminal
*/
//Early control page
/*
class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ControlPage createState() => _ControlPage();

} //ControlPage


class _ControlPage extends State<Control> {
  var title = hostname! + username! + password!;
  int buttonState = 1;
  bool whileLoop = false;late SSHClient client2;
  @override
  void initState() {
    super.initState();
    initControl();
  }
  @override
  void dispose(){
    super.dispose();
  }
  Future<void> initControl() async {
    client2 = SSHClient(
      await SSHSocket.connect(hostname!, port),
      username: username!,
      onPasswordRequest: () => password!,
    );
    var result1 = await client2.run("raspi-gpio set 21 op"); print("INITIATED");
    /*while(whileLoop){
      var result2 = await client2.run("raspi-gpio set 21 dh"); print(utf8.decode(result2));
      await Future.delayed(Duration(microseconds: 100000));
      var result3 = await client2.run("raspi-gpio set 21 dl"); print(utf8.decode(result3));
      await Future.delayed(Duration(microseconds: 100000));
    }*/
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 64,
        shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: bgcolor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //left alignment for texts
          children: [
            Text(nickname!,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 21)),
            Text(distro!,style: GoogleFonts.poppins(color: textcolor, fontSize: 12)),
          ],
        ),
        backgroundColor: bgcolor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back, color: textcolor,))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: [
          Container(
            height: 40,
            width: 40,
            color: Colors.yellow,
            child: IconButton(
              icon: Icon(Icons.upload),
              onPressed: () async {
                whileLoop = !whileLoop;
                while(whileLoop){
                  var result2 = await client2.run("raspi-gpio set 21 dh"); print(utf8.decode(result2));
                  await Future.delayed(const Duration(microseconds: 100000));
                  var result3 = await client2.run("raspi-gpio set 21 dl"); print(utf8.decode(result3));
                  await Future.delayed(Duration(microseconds: 100000));
              }}
            )
          ),
          Container(
            height: 40,
            width: 40,
            color: Colors.grey,
          ),
          Container(
            height: 40,
            width: 40,
            color: Colors.green,
          ),
          Container(
            height: 40,
            width: 40,
            color: Colors.black,
          ),

        ],

      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
      ),
    );
  }
} //TerminalState
*/
/*FutureBuilder(
        future: updateSpaceRender(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            final currentSpaceList = snapshot.data;
            return ListView.builder(
              itemCount: currentSpaceList.length,
                itemBuilder: (context, index){
                return ListTile(
                  title: Text(currentSpaceList[index]),
                  leading: Icon(Icons.one_k),
                );
                });
          }
          return Text("loading");
        },
      ) */


