import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:v2_1/create_new_project/components/ssh_info_page.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/instruction_text.dart';
import 'package:v2_1/universal_widget/talking_head.dart';


class raspberryPiSetup extends StatelessWidget {
  const raspberryPiSetup({super.key, required this.project_name, required this.project_description, required this.imgURL});
  final String project_name; final String project_description; final String imgURL;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: raspberryPiSetupSteps,
          showNextButton: false,
          done: clickable_text(text: 'next', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SSHInfoPage(project_name: project_name, project_description: project_description, imgURL: imgURL)));
          },),
          onDone: () {
            // On button pressed, move to next page
            if (kDebugMode) {
              print('setup finished');
            }
          },
        ),
      )
    );
  }
}

List<PageViewModel> raspberryPiSetupSteps = [
  //Required hardware
  PageViewModel(
    decoration: const PageDecoration(
    ),
    titleWidget: const talkingHead(text: 'Now, we will gather the necessary hardware (below). This serves as the brain of most robots.',),
    bodyWidget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const instructionTitle(text: '1. A Raspberry Pi Zero 2W'),
        Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/RPiZ2W.png'),
        ),
        const instructionTitle(text: '2. A Micro SD Card'),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/tutorials/MicroSDCard.png'),
        ),
        const instructionTitle(text: '3. A Power Supply'),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/tutorials/RPiPowerSupply.png'),
        ),
      ],
    )
  ),
  //Download RPi Imager
  PageViewModel(
      decoration: const PageDecoration(
      ),
      titleWidget: const talkingHead(text: 'Next, let\'s get the software ready!',),
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const instructionTitle(text: '1. Open your computer'),
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/Computer.png'),
          ),
          const instructionTitle(text: '2. Download Raspberry Pi Imager'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/DownloadRpiImager.png'),
          ),
          const instructionTitle(text: '3. Install & open the software'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/InstallRpiImager.png'),
          ),
        ],
      )
  ),
  //Imager Options
  PageViewModel(
      decoration: const PageDecoration(
      ),
      titleWidget: const talkingHead(text: 'Now that the software is downloaded, let\'s set up your Raspberry Pi - the brain of your robot.',),
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const instructionTitle(text: '1. Plug the Micro-SD card into your computer'),
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/PlugSDCard.png'),
          ),
          const instructionTitle(text: '2. Click "Choose Device".'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerPickDevice.png'),
          ),
          const instructionTitle(text: '3. Click "Choose OS".'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerPickOS.png'),
          ),
          const instructionTitle(text: '4. Click "Choose Storage".'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerPickSDCard.png'),
          ),
        ],
      )
  ),
  //Secret Menu
  PageViewModel(
      decoration: const PageDecoration(
      ),
      titleWidget: const talkingHead(text: 'Next, let\'s setup a remote connection for the Raspberry Pi.',),
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const instructionTitle(text: '1. Open the "secret menu".'),
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerSecretMenu.png'),
          ),
          const instructionTitle(text: '2. Pick a hostname of your choice.'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerHostname.png'),
          ),
          const instructionTitle(text: '3. Pick a username & password'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerUserPassword.png'),
          ),
          const instructionTitle(text: '4. Enter your wifi information'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerWifiInfo.png'),
          ),
          const instructionTitle(text: '5. Enable SSH'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerEnableSSH.png'),
          ),
          const instructionTitle(text: '5. Flash the Operating Sytem (OS)'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerFlash.png'),
          ),
          const instructionTitle(text: '5. Wait for a few minutes'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ImagerFlashDone.png'),
          ),
        ],
      )
  ),
  //Congrats, you are finished!
  PageViewModel(
      decoration: const PageDecoration(
      ),
      titleWidget: const talkingHead(text: 'Lastly, power up your Raspberry Pi!.',),
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const instructionTitle(text: '1. Plug the Micro-SD in'),
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/SDPlugToRpi.png'),
          ),
          const instructionTitle(text: '2. Plug the Raspberry Pi to the power supply.'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/PowerSupplyToRpi.png'),
          ),
          const instructionTitle(text: '3. On your computer, open PowerShell (Windows) or Terminal (MacOS).'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/OpenTerminal.png'),
          ),
          const instructionTitle(text: '4. Run commands to scan for Raspberry Pi IP address.'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ScanIPWindows.png'),
          ),
          const instructionTitle(text: 'or'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/tutorials/ScanIPMac.png'),
          ),
          const instructionTitle(text: '5. Congrats! You have finished setting up your Raspberry Pi, the brain of your robot.'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.network('https://comfyspace.tech/chilling-in-the-park.jpg'),
          ),
          const instructionTitle(text: 'Hi! I\'m Thomas and I\'m proud of your progress so far! Remember to note down the IP address, username & password (last step).'),

        ],
      )
  ),
];

