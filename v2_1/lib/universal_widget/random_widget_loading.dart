import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class randomLoadingWidget extends StatelessWidget {
  const randomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {

    List<Widget> loadingWidgetList = [
      SpinKitPumpingHeart(
        color: Theme.of(context).colorScheme.primary,
        size: 50.0,
      ),
      SpinKitWave(
        color: Theme.of(context).colorScheme.primary,
        size: 50.0,
      ),
      SpinKitPouringHourGlassRefined(
        color: Theme.of(context).colorScheme.primary,
        size: 50.0,
      ),
    ];

    int widgetIndex = Random().nextInt(loadingWidgetList.length);

    return loadingWidgetList[widgetIndex];
  }
}
