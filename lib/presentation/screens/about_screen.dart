import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/my_theme.dart';
import '../components/header_footer.dart';
import '../components/space.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actionChips = Row(
      children: [
        ActionChip(
          label: const Text("Share app"),
          avatar: const Icon(
            Icons.share,
            // color: Color(0xff0077B5),
          ),
          onPressed: () => Share.share(
            'https://play.google.com/store/apps/details?id=com.sohaibcreates.pointr',
          ),
        ),
        12.horizontalSpace,
        ActionChip(
          label: const Text("GitHub"),
          avatar: const Icon(
            Bootstrap.github,
            color: Color(0xff0077B5),
          ),
          onPressed: () => launchUrl(
            Uri.parse(
              'https://www.github.com/sohaibbg/pointr',
            ),
          ),
        ),
      ],
    );
    final aboutPointr = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final height = MediaQuery.sizeOf(context).height;
            final topPadding = height < 732
                ? 96
                : height < 800
                    ? 172
                    : 320;
            return topPadding.verticalSpace;
          },
        ),
        Text(
          "About pointr",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.grey.shade800),
          textAlign: TextAlign.start,
        ),
        12.verticalSpace,
        actionChips,
        12.verticalSpace,
        const Text(
          '''Pointr was started out of a desire to make it easier to navigate bus systems in Karachi.
          
You can contribute to the routes collection by adding a pull request to our GitHub repo.''',
          textAlign: TextAlign.start,
        ),
      ],
    );
    final footer = ColoredBox(
      color: Color.lerp(
        MyTheme.primaryColor.shade50,
        Colors.white,
        0.7,
      )!,
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 12,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: const DrawerButton(),
        ),
      ),
    );
    return ColoredBox(
      color: Colors.white,
      child: HeaderBackdrop(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  aboutPointr,
                  100.verticalSpace,
                ],
              ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}
