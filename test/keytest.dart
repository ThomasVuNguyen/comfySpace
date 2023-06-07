
class KeyPressSimulator {
  final SimulateKeyPress simulateKeyPress;

  KeyPressSimulator() :
        simulateKeyPress = _loadSimulateKeyPress() {
    // Initialize any necessary setup
  }

  static SimulateKeyPress _loadSimulateKeyPress() {
    final dylib = DynamicLibrary.open('native_key_press.so'); // Replace with the actual dynamic library file name
    return dylib
        .lookupFunction<NativeSimulateKeyPress, SimulateKeyPress>('simulateKeyPress');
  }

  void simulateKey(int keyCode) {
    simulateKeyPress(keyCode);
  }
}

class KeyPressSimulatorWidget extends StatelessWidget {
  final KeyPressSimulator keyPressSimulator = KeyPressSimulator();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          // Simulate keypress event
          keyPressSimulator.simulateKey(29); // Pass the desired key code
        },
        child: Icon(Icons.keyboard),
      );
  }
}


