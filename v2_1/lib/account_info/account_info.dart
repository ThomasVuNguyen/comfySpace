import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2_1/account_info/components/action_button.dart';
import 'package:v2_1/account_info/components/information_field.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/sendEmail.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/userIdentifier.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:slider_button/slider_button.dart';
import '../comfyauth/authentication/auth.dart';

class account_info extends StatefulWidget {
  const account_info({super.key, required this.name, required this.tagline});
  final String? name; final String? tagline;
  @override
  State<account_info> createState() => _account_infoState();
}

class _account_infoState extends State<account_info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
            children: [
            Center(
              child: Text(
                'Account',
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
              Positioned(
                left: 0,
                  child: IconButton(
                      onPressed: (){Navigator.pop(context);},
                      icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary,)
                  ))
            ],
            ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: FractionallySizedBox(heightFactor: 0.2,)),
            avatar_icon(size: 80,),
            Gap(20),
            Text('${widget.name}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
            Text('${widget.tagline}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
            Gap(20),
            Flexible(child: FractionallySizedBox(heightFactor: 0.3,)),

            //Log out button
            (Platform.isAndroid || Platform.isIOS)?
            Center(child: SliderButton(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              baseColor: Theme.of(context).colorScheme.secondaryContainer,
              buttonColor: Theme.of(context).colorScheme.onSecondaryContainer,
              highlightedColor: Colors.red,
              shimmer: false,
              action: () async {
                // show loading screen
                showDialog(context: context, builder: (context){
                  return const Center(child: CircularProgressIndicator(),);
                });
                // check if currently google sign in

                if (await GoogleSignIn().isSignedIn()){
                  await GoogleSignIn().disconnect();
                }
                // try signing out
                FirebaseAuth.instance.signOut();

                // pop the loading circle
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const auth_page(welcomePage: true,)));
              },
              label: Text(
                "Sign out",
                style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)
              ),
              icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.secondaryContainer
                ,)

            ))
                :clickable_text(
                text: 'Sign out',
                onTap: () async {
                  // show loading screen
                  showDialog(context: context, builder: (context){
                    return const Center(child: CircularProgressIndicator(),);
                  });
                  // check if currently google sign in

                  if (await GoogleSignIn().isSignedIn()){
                    await GoogleSignIn().disconnect();
                  }
                  // try signing out
                  FirebaseAuth.instance.signOut();

                  // pop the loading circle
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const auth_page(welcomePage: true,)));
                }
            ),
            const Gap(20),
            (Platform.isAndroid || Platform.isIOS)?
            Center(child: SliderButton(
                backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                baseColor: Theme.of(context).colorScheme.tertiaryContainer,
                buttonColor: Theme.of(context).colorScheme.onTertiaryContainer,
                highlightedColor: Colors.red,
                shimmer: false,
                action: () async{
                  String? email = getUserID().toString();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forwarding to support site')));
                  await(launchUrl(Uri.parse('https://comfyspace.tech/support')));
                  await sendEmailGeneral('$email needs support');
                },
                label: Text(
                    "Request support",
                    style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer)
                ),
                icon: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.tertiaryContainer
                  ,)

            ))
                : clickable_text(
                text: 'Need support/information ?' ,
                onTap: () async{
                  String? email = getUserID().toString();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forwarding to support site')));
                  await(launchUrl(Uri.parse('https://comfyspace.tech/support')));
                  await sendEmailGeneral('$email needs support');
                }),
            Gap(20),
            (Platform.isAndroid || Platform.isIOS)?
            Center(child: SliderButton(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                baseColor: Theme.of(context).colorScheme.errorContainer,
                buttonColor: Theme.of(context).colorScheme.onErrorContainer,
                highlightedColor: Colors.red,
                shimmer: false,
                action: () async{
                  String? email = getUserID().toString();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion requested, will complete in 48 hours')));
                  await sendEmailGeneral('$email would like to delete their account');
                },
                label: Text(
                    "Delete account",
                    style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onErrorContainer)
                ),
                icon: Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.errorContainer
                  ,)

            ))
                :clickable_text(
                text: 'Request account deletion',
                onTap: () async{
                  String? email = getUserID().toString();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion requested, will complete in 48 hours')));
                  await sendEmailGeneral('$email would like to delete their account');
                }),
            const Gap(20),

          ],
        ),
      )
      /*Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  avatar_icon(size: 60,),
                  Gap(20),
                  Text('${widget.name}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ),
                  Text('${widget.tagline}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),

                  ExpansionTile(
                      title: Text('Options', style: Theme.of(context).textTheme.titleMedium,),
                    children: [
                      clickable_text(
                          text: 'Sign out',
                          onTap: () async {
                            // show loading screen
                            showDialog(context: context, builder: (context){
                              return const Center(child: CircularProgressIndicator(),);
                            });
                            // check if currently google sign in

                            if (await GoogleSignIn().isSignedIn()){
                              await GoogleSignIn().disconnect();
                            }
                            // try signing out
                            FirebaseAuth.instance.signOut();

                            // pop the loading circle
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const auth_page(welcomePage: true,)));
                          }
                      ),
                      const Gap(20),
                      clickable_text(
                          text: 'Request account deletion',
                          onTap: () async{
                            String? email = getUserID().toString();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion requested, will complete in 48 hours')));
                            await sendEmailGeneral('$email would like to delete their account');
                          }),
                      const Gap(20),
                      clickable_text(
                          text: 'Need support/information ?' ,
                          onTap: () async{
                        String? email = getUserID().toString();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forwarding to support site')));
                        await(launchUrl(Uri.parse('https://comfyspace.tech/support')));
                        await sendEmailGeneral('$email needs support');
                      }),
                      Gap(20)
                    ],
                  )
                ],
              ),
            ],
          ),
        ),),*/
    );
  }
}
