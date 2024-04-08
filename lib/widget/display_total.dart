import 'package:diet_junkie/design.dart';
import 'package:diet_junkie/object/macro.dart';
import 'package:diet_junkie/widget/color_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DisplayTotal extends HookConsumerWidget {
  double vCal = 2500;
  double vprot = 30;
  double vlip = 20;
  double vglu = 50;

  Macros macro;

  DisplayTotal({
    required this.macro,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double mt = macro.protide * 4 + macro.glucide * 4 + macro.lipide * 9;
    double ratio(double t, double v) {
      return (((t / mt) * 100) / v) * 100;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              macro.calorie.toStringAsFixed(0),
              style: whiteTextStyle(30),
            ),
            Text(
              ' Kcal',
              style: whiteTextStyle(25),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorText(
                      size: 25,
                      ratio: ratio(macro.protide * 4, vprot),
                      text: macro.protide == 0
                          ? '0'
                          : '${(((macro.protide * 4) / ((macro.protide * 4) + (macro.glucide * 4) + (macro.lipide * 9))) * 100).toStringAsFixed(0)}%'),
                  Text(
                    'Protide',
                    style: blackTextStyle(10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorText(
                      size: 25,
                      ratio: ratio(macro.lipide * 9, vlip),
                      text: macro.lipide == 0
                          ? '0'
                          : '${(((macro.lipide * 9) / ((macro.protide * 4) + (macro.glucide * 4) + (macro.lipide * 9))) * 100).toStringAsFixed(0)}%'),
                  Text(
                    'Lipide',
                    style: blackTextStyle(10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorText(
                      size: 25,
                      ratio: ratio(macro.glucide * 4, vglu),
                      text: macro.glucide == 0
                          ? '0'
                          : '${(((macro.glucide * 4) / ((macro.protide * 4) + (macro.glucide * 4) + (macro.lipide * 9))) * 100).toStringAsFixed(0)}%'),
                  Text(
                    'Glucide',
                    style: blackTextStyle(10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
