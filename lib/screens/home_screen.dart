import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:electronic_vehicle_controller/constanins.dart';
import 'package:electronic_vehicle_controller/home_controller.dart';
import 'package:electronic_vehicle_controller/models/TyrePsi.dart';
import 'package:electronic_vehicle_controller/screens/components/battery_status.dart';
import 'package:electronic_vehicle_controller/screens/components/door_lock.dart';
import 'package:electronic_vehicle_controller/screens/components/temp_details.dart';
import 'package:electronic_vehicle_controller/screens/components/tesla_bottom_nav.dart';
import 'package:electronic_vehicle_controller/screens/components/tyre_psi_card.dart';
import 'package:electronic_vehicle_controller/screens/components/tyres.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animateCarShift;
  late Animation<double> _animateTempShowInfo;
  late Animation<double> _animateCarGlow;

  late AnimationController _tyreAnimationController;
  late Animation<double> _animateTyre1Psi;
  late Animation<double> _animateTyre2Psi;
  late Animation<double> _animateTyre3Psi;
  late Animation<double> _animateTyre4Psi;

  late List<Animation<double>> _tyreAnimations;

  void setupBatteryAnimation() {
    _batteryAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

//this animation ends at 0.5, i.e half of the parent(300 mil)
    _animationBattery = CurvedAnimation(
        parent: _batteryAnimationController, curve: Interval(0.0, 0.5));
//then this animation beguins at 0.6 and ends at 1, i.e, it begin after the firsty animation ends(battrey pannel)
    _animationBatteryStatus = CurvedAnimation(
        parent: _batteryAnimationController, curve: Interval(0.6, 1));
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _animateCarShift = CurvedAnimation(
        parent: _tempAnimationController, curve: Interval(0.2, 0.4));

    _animateTempShowInfo = CurvedAnimation(
        parent: _tempAnimationController, curve: Interval(0.45, 0.65));
    _animateCarGlow = CurvedAnimation(
        parent: _tempAnimationController, curve: Interval(0.7, 1));
  }

  void setTyreAnimation() {
    _tyreAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

//start after about 400 milliseconds, coz tyres were delays for 400milliseconds
//1200 * 0.34 =408sec
//1200 * 0.5
    _animateTyre1Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.34, 0.5));

    //start from where _animateTyre1Psi ends
    _animateTyre2Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.5, 0.66));

    _animateTyre3Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.66, 0.82));

    _animateTyre4Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.82, 1));
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setTyreAnimation();
    _tyreAnimations = [
      _animateTyre1Psi,
      _animateTyre2Psi,
      _animateTyre3Psi,
      _animateTyre4Psi,
    ];
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _batteryAnimationController,
          _tempAnimationController,
          _tyreAnimationController,
        ]),
        builder: (context, snapshot) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavBar(
              onTap: (index) {
                if (index == 1) {
                  _batteryAnimationController.forward();
                } else if (_controller.selectedBottomTab == 1 && index != 1) {
                  _batteryAnimationController.reverse(from: 0.7);
                }
                if (index == 2) {
                  _tempAnimationController.forward();
                } else if (_controller.selectedBottomTab == 2 && index != 2) {
                  _tempAnimationController.reverse(from: 0.4);
                }

                if (index == 3) {
                  _tyreAnimationController.forward();
                } else if (_controller.selectedBottomTab == 3 && index != 3) {
                  _tyreAnimationController.reverse();
                }

                _controller.showTyreController(index);
                _controller.tyreStatusController(index);

                _controller.updateBottomNavBar(index);
                //  print(_animationBattery.value);
              },
              selectedTab: _controller.selectedBottomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                    Positioned(
                      left: constraints.maxWidth / 2 * _animateCarShift.value,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: constraints.maxWidth * 0.1),
                        child: SvgPicture.asset(
                          "assets/icons/Car.svg",
                          width: double.infinity,
                        ),
                      ),
                    ),
                    //right door lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    //left door lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    //bonnet lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.16
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetLock,
                        ),
                      ),
                    ),
                    //booth lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.15
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBoothLock,
                          press: _controller.updateBoothLock,
                        ),
                      ),
                    ),
                    //battery
                    Opacity(
                      opacity: _animationBattery.value,
                      // duration: defaultDuration,
                      child: SvgPicture.asset(
                        "assets/icons/Battery.svg",
                        width: constraints.maxWidth * 0.45,
                      ),
                    ),
                    //battery status
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(
                          constraints: constraints,
                        ),
                      ),
                    ),
                    //Temp
                    Positioned(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      top: 60 * (1 - _animateTempShowInfo.value),
                      child: Opacity(
                        opacity: _animateTempShowInfo.value,
                        child: TemDetails(
                          controller: _controller,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -180 * (1 - _animateCarGlow.value),
                      child: AnimatedSwitcher(
                        duration: defaultDuration,
                        child: _controller.isCoolSelected
                            ? Image.asset(
                                "assets/images/Cool_glow_2.png",
                                width: 200,
                                key: UniqueKey(),
                              )
                            : Image.asset(
                                "assets/images/Hot_glow_4.png",
                                width: 200,
                                key: UniqueKey(),
                              ),
                      ),
                    ),
                    //Tyre
                    if (_controller.isShowTyre) ...tyres(constraints),
                    if (_controller.isShowTyreStatus)
                      GridView.builder(
                        itemCount: 4,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: defaultPadding,
                            crossAxisSpacing: defaultPadding,
                            childAspectRatio:
                                constraints.maxWidth / constraints.maxHeight),
                        itemBuilder: (context, index) => ScaleTransition(
                          scale: _tyreAnimations[index],
                          child: TyrePsiCard(
                            isBottomTwoTyres: index > 1,
                            tyrePsi: demoPsiList[index],
                          ),
                        ),
                      )
                  ],
                );
              }),
            ),
          );
        });
  }
}
