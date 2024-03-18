import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';

class project_list extends StatelessWidget {
  const project_list({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Column(
        children: [
          project_card(),
          add_project_card()
        ],
      ),),
    );
  }
}

class project_card extends StatelessWidget {
  const project_card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant
        ),
          color: Theme.of(context).colorScheme.surface
        ),
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(11), topRight: Radius.circular(11)
        ),
                child: Image.network('https://images.unsplash.com/photo-1571769267292-e24dfadebbdc?q=80&w=1490&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')),
            Container(height: 60, alignment: Alignment.center,
                child: Text('-Project name-', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
            Container(
              height: 30, alignment: Alignment.center,
                child: Text('-project description-', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
          ],
        ),
      ),
    );
  }
}

class add_project_card extends StatelessWidget {
  const add_project_card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DottedBorder(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderType: BorderType.RRect,
        padding: EdgeInsets.all(40),
        radius: Radius.circular(12),
        strokeWidth: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 50, alignment: Alignment.center,
                child: Text('Create a project', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
            Container(
                height: 30, alignment: Alignment.center,
                child: Text('~ let your creativity fly ~', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
          ],
        ),
      ),
    );
  }
}

