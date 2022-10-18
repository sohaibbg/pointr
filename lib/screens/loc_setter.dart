import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointr/classes/star.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/widgets/horizontal_chip_scroller.dart';
import 'package:sizer/sizer.dart';

class LocSetter extends StatefulWidget {
  const LocSetter({super.key});

  @override
  State<LocSetter> createState() => _LocSetterState();
}

class _LocSetterState extends State<LocSetter> {
  TextEditingController controller = TextEditingController();
  List<Star> filteredStars = Star.all;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.colorPrimary,
          toolbarHeight: 10.h,
          leadingWidth: 0,
          titleSpacing: 0,
          flexibleSpace: Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            // repeat: ImageRepeat.repeat,
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // subtitle
              Padding(
                padding: EdgeInsets.only(left: 56 + 1.w, bottom: 0.5.h),
                child: const Text(
                  "LEAVING FROM",
                  style: MyTheme.subtitle,
                ),
              ),
              // textfield
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Flexible(
                      child: TextField(
                        autofocus: true,
                        decoration: MyTheme.addressFieldStyle,
                        onChanged: (searchTerm) => setState(
                          () => searchTerm.isEmpty
                              ? filteredStars = Star.all
                              : filteredStars = Star.all
                                  .where(
                                    (star) => star.name
                                        .toLowerCase()
                                        .removeAllWhitespace
                                        .contains(searchTerm
                                            .toLowerCase()
                                            .removeAllWhitespace),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            // chip scroller
            SizedBox(
              height: filteredStars.isNotEmpty ? 5.5.h + 32 : 0,
              width: 200,
              child: HorizontalChipScroller(
                items: filteredStars,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                // horizontalPadding: 56,
                onSelected: (Star star) {},
                // bgColor: MyTheme.colorPrimaryLight,
              ),
            ),
          ],
        ),
      );
}
