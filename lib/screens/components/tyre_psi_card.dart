import 'package:flutter/material.dart';
import 'package:electronic_vehicle_controller/constanins.dart';
import 'package:electronic_vehicle_controller/models/TyrePsi.dart';

class TyrePsiCard extends StatelessWidget {
  const TyrePsiCard({
    Key? key,
    required this.isBottomTwoTyres,
    required this.tyrePsi,
  }) : super(key: key);
  final bool isBottomTwoTyres;
  final TyrePsi tyrePsi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: tyrePsi.isLowPressure
              ? redColor.withOpacity(0.1)
              : Colors.white10,
          border: Border.all(
              color: tyrePsi.isLowPressure ? redColor : primaryColor, width: 2),
          borderRadius: BorderRadius.circular(6)),
      child: isBottomTwoTyres
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              lowPressureText(context),
              Spacer(),
              psiText(context, psi: tyrePsi.psi.toString()),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(
                "${tyrePsi.temp}\u2103",
                style: TextStyle(fontSize: 16),
              ),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              psiText(context, psi: tyrePsi.psi.toString()),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(
                "${tyrePsi.temp}\u2103",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              lowPressureText(context),
            ]),
    );
  }

  Widget lowPressureText(BuildContext context) {
    return Column(
      children: [
        Text(
          "Low".toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        Text(
          "PRESSURE",
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Text psiText(BuildContext context, {required String psi}) {
    return Text.rich(
      TextSpan(
          text: psi,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: "psi",
              style: TextStyle(fontSize: 24),
            )
          ]),
    );
  }
}
