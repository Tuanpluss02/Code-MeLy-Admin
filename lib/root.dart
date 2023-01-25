import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mely_admin/models/rive_assets.dart';
import 'package:mely_admin/pages/events_page.dart';
import 'package:mely_admin/pages/home_page.dart';
import 'package:mely_admin/pages/search_page.dart';
import 'package:mely_admin/pages/setting_page.dart';
import 'package:mely_admin/pages/users_page.dart';
import 'package:mely_admin/utils/rive_utils.dart';
import 'package:rive/rive.dart';

class RootTree extends StatefulWidget {
  const RootTree({super.key});

  @override
  State<RootTree> createState() => _RootTreeState();
}

class _RootTreeState extends State<RootTree> {
  // ignore: prefer_final_fields
  RxInt _selected = 0.obs;

  List pages = [
    const HomePage(),
    const SearchPage(),
    const EventPage(),
    const UserPage(),
    const SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => pages[_selected.value],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                  botIcons.length,
                  (index) => GestureDetector(
                        onTap: () {
                          botIcons[index].input?.value = true;
                          if (_selected.value != index) {
                            _selected.value = index;
                          }
                          Future.delayed(const Duration(seconds: 1), () {
                            botIcons[index].input?.value = false;
                          });
                        },
                        child: SizedBox(
                          height: 36,
                          width: 36,
                          child: Obx(
                            () => Opacity(
                              opacity: _selected.value == index ? 1 : 0.5,
                              child: RiveAnimation.asset(
                                'assets/rive/icons.riv',
                                artboard: botIcons[index].arboard,
                                onInit: (artboard) {
                                  StateMachineController controller =
                                      RivetUtils.getRiveController(artboard,
                                          stateMachine:
                                              botIcons[index].stateMachine);
                                  botIcons[index].input =
                                      controller.inputs.first as SMIBool;
                                },
                              ),
                            ),
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
