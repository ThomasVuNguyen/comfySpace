import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/comfyauth/authentication/components/auth_button.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/universal_widget/buttons.dart';

class set_user_info extends StatefulWidget {
  const set_user_info({super.key});

  @override
  State<set_user_info> createState() => _set_user_infoState();
}

class _set_user_infoState extends State<set_user_info> {
  @override
  void initState() {
    add_user_to_database();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final taglineController = TextEditingController();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'How should we call you?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.tertiary
                )
              ),
              Gap(20),
              Image.asset('assets/froggie/welcoming_froggie.png'),
              Gap(20),
              in_app_textfield(
                  titleText: 'Pick a username',
                  controller: nameController,
                  hintText: 'Thomas the Maker',
                  obsureText: false,
              ),
              Gap(20),
              in_app_textfield(
                  titleText: 'Pick a tagline',
                  controller: taglineController,
                  hintText: 'Loves to tinker',
                  obsureText: false
              ),
              Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  clickable(icon: Icons.close, onTap: (){
                    Navigator.pop(context);
                  }),
          
                  clickable(icon: Icons.check, onTap: () async{
                   if(nameController.text == '' || taglineController.text=='' ||nameController.text== null || taglineController.text==null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('information cannot be blank')));
                    }
                    else{
                      await update_user_information(nameController.text, taglineController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                      setState((){});
                    }
                  },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}



class in_app_textfield extends StatefulWidget {
  const in_app_textfield({super.key, required this.controller, required this.hintText, required this.obsureText, required this.titleText, this.maxWidth = 1000, this.initialValue = '',
    this.multiline = false
  });
  final TextEditingController controller; final String hintText; final bool obsureText; final String titleText; final double maxWidth; final String initialValue;
  final bool multiline;
  @override
  State<in_app_textfield> createState() => _in_app_textfieldState();
}

class _in_app_textfieldState extends State<in_app_textfield> {
  @override
  void initState() {
    //pre fill Textfield with value if initial value is set
    if(widget.initialValue !=''){
      widget.controller.text = widget.initialValue;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1000,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.titleText,
                  style: Theme.of(context).textTheme.titleMedium,
              ),
              Gap(10),
              TextField(
                maxLines: (widget.multiline == true)? 5 :1,
                keyboardType: (widget.multiline == true)? TextInputType.multiline: TextInputType.text,
                textInputAction: TextInputAction.next,
                obscureText: widget.obsureText,
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
