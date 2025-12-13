import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intro_slider/intro_slider.dart';

class InstructionsScreen extends ConsumerStatefulWidget {
  const InstructionsScreen({super.key});
  @override
  InstructionsScreenState createState() => InstructionsScreenState();
}

class InstructionsScreenState extends ConsumerState<InstructionsScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
       ContentConfig(
        title: "welcome".tr(),
        description:
        "welcome_to_drive_sense".tr(),
        pathImage: "assets/steps/welcome.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: "connect_raspberry_pi".tr(),
        description:
        "make_sure_you".tr(),
        pathImage: "assets/steps/connect.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: "get_started".tr(),
        description:
        "go_to_drive_page".tr(),
        pathImage: "assets/steps/get_started.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: listContentConfig,
      isShowDoneBtn: false,
      isShowSkipBtn: false,
      isShowPrevBtn: false,
      isShowNextBtn: false,
    );
  }
}

