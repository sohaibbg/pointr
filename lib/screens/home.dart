import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointr/classes/star.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/screens/loc_setter.dart';
import 'package:pointr/widgets/horizontal_chip_scroller.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          // backdrop
          Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          // foreground
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // title
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                  left: 7.w,
                  right: 7.w,
                  bottom: 2.h,
                ),
                child: const Text(
                  "Where do you want to go?",
                  style: MyTheme.heading1,
                ),
              ),
              // textfield
              Padding(
                padding: EdgeInsets.fromLTRB(7.w, 0, 7.w, 2.h),
                child: TextField(
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.search, color: MyTheme.colorSecondaryDark),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.colorSecondaryDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyTheme.colorSecondaryDark),
                    ),
                    hintText: 'Enter Destination...',
                    filled: true,
                    fillColor: MyTheme.colorSecondaryLight,
                    hintStyle:
                        TextStyle(color: MyTheme.colorSecondaryDarkAccent),
                  ),
                  onTap: () {
                    Get.to(() => const LocSetter());
                    focusNode.unfocus();
                  },
                ),
              ),
              // starred
              Flexible(
                child: FutureBuilder(
                  future: Star.updateAll(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.done
                          ? SizedBox(
                              height: 6.h,
                              child: HorizontalChipScroller(
                                items: Star.all,
                                onSelected: (_) {},
                              ),
                            )
                          : const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
