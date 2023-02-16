import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:electronic_vehicle_controller/constanins.dart';

class DoorLock extends StatelessWidget {
  const DoorLock({Key? key, required this.press, required this.isLock})
      : super(key: key);

  final VoidCallback press;
  final bool isLock;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: press,
      child: AbsorbPointer(
        child: AnimatedSwitcher(
          duration: defaultDuration,
          switchInCurve: Curves.easeInOutBack, //bouncing effect
          transitionBuilder: (child, animation) => ScaleTransition(
            //adding the scall effect
            scale: animation,
            child: child,
          ),
          child: isLock
              ? SvgPicture.asset("assets/icons/door_lock.svg",
                  key: ValueKey("lock_door"))
              : SvgPicture.asset(
                  "assets/icons/door_unlock.svg",
                  key: ValueKey("unlock"),
                ),
        ),
      ),
    );
  }
}
