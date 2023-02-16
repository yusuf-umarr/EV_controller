import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:electronic_vehicle_controller/constanins.dart';

class TeslaBottomNavBar extends StatelessWidget {
  TeslaBottomNavBar({
    Key? key,
    required this.selectedTab,
    required this.onTap,
  }) : super(key: key);
  final int selectedTab;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: onTap,
        currentIndex: selectedTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: List.generate(
            navIcons.length,
            (index) => BottomNavigationBarItem(
                icon: SvgPicture.asset(navIcons[index],
                    color: index == selectedTab ? primaryColor : Colors.white),
                label: "")));
  }

  List<String> navIcons = [
    "assets/icons/Lock.svg",
    "assets/icons/Charge.svg",
    "assets/icons/Temp.svg",
    "assets/icons/Tyre.svg",
  ];
}
