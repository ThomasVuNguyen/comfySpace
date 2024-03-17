import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';

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
        Text('${widget.name}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),),
        Text('${widget.tagline}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
        signout_button(),
      ],
    ),);
  }
}
