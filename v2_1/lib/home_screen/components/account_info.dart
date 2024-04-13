import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';

import '../../comfyauth/authentication/auth.dart';

class account_info extends StatefulWidget {
  const account_info({super.key, required this.name, required this.tagline});
  final String? name; final String? tagline;
  @override
  State<account_info> createState() => _account_infoState();
}

class _account_infoState extends State<account_info> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //avatar_icon(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${widget.name}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), textAlign: TextAlign.center,),
                    IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const set_user_info()),
                      );
                    }
                        , icon: Icon(Icons.edit))
                  ],
                ),
                Gap(20),
                Text('${widget.tagline}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  textAlign: TextAlign.center,
                ),
                Gap(20)
              ],
            ),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3),
              child: Divider(thickness: 0.5, color: Theme.of(context).colorScheme.onBackground,),
            ),
            Gap(20),
            clickable_text(
                text: 'Wanna sign out ?',
                onTap: () async {
                  // show loading screen
                  showDialog(context: context, builder: (context){
                    return Center(child: CircularProgressIndicator(),);
                  });
                  // check if currently google sign in

                  if (await GoogleSignIn().isSignedIn()){
                    await GoogleSignIn().disconnect();
                  }
                  // try signing out
                  FirebaseAuth.instance.signOut();

                  // pop the loading circle
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => auth_page(welcomePage: true,)));
                }
            )
          ],
        ),

      ],
    ),);
  }
}
