import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/my_theme.dart';
import '../../infrastructure/services/images/portfolio_image.dart';
import '../components/header_footer.dart';
import '../components/space.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .displayMedium
        ?.copyWith(color: Colors.grey.shade800);
    final aboutPointr = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        200.verticalSpace,
        Text(
          "About pointr",
          style: titleStyle,
          textAlign: TextAlign.start,
        ),
        20.verticalSpace,
        const Text(
          "Pointr was started out of a desire to make it easier to navigate bus systems in Karachi. Whilst currently only the newer air-conditioned buses are supported, the app will feature minibus and chinchi routes with a community contribution model for aggregating routes in the future.",
          textAlign: TextAlign.start,
        ),
      ],
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
                  24.verticalSpace,
                  _AboutTheDev(titleStyle: titleStyle),
                  100.verticalSpace,
                ],
              ),
            ),
            ColoredBox(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutTheDev extends StatelessWidget {
  const _AboutTheDev({
    required this.titleStyle,
  });

  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      "About the Developer",
      style: titleStyle,
      textAlign: TextAlign.start,
    );
    final actionChipsRow = Row(
      children: [
        ActionChip(
          label: const Text("LinkedIn"),
          avatar: const Icon(
            Bootstrap.linkedin,
            color: Color(0xff0077B5),
          ),
          onPressed: () => launchUrl(
            Uri.parse(
              'https://www.linkedin.com/in/sohaibbaig1/',
            ),
          ),
        ),
        12.horizontalSpace,
        ActionChip(
          label: const Text("Resume"),
          avatar: const Icon(Icons.file_copy_rounded),
          onPressed: () => launchUrl(
            Uri.parse(
              'https://drive.google.com/file/d/1Fc54lbC0LWPEEjdIL455sv2KlsVnLSh0/view?usp=share_link',
            ),
          ),
        ),
      ],
    );
    final pureversity = Column(
      children: [
        const Text(
          "Hi, I'm Sohaib! I've always had a passion for all things related to sustainability, urban studies, sustainability and of course, technology. That's why one of my first startups was a zero-waste shampoo brand!\n\nIn my career as a Software Engineer, I led the team that developed a Role Playing Game for employees' training in Cybersecurity. This was a web application based in Flutter and used optimized SQL queries and a NodeJS backend with open-source FusionAuth for auth.",
        ),
        12.verticalSpace,
        Image.asset(
          PortfolioImage.pureversity.path,
        ),
        4.verticalSpace,
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                const TextSpan(
                  text: "Check out ",
                ),
                TextSpan(
                  text: "Pureversity.com",
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrl(
                          Uri.parse('https://www.pureversity.com'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    final fcsc = Column(
      children: [
        const Text(
          "In 2023, I joined the Federal Competitiveness and Statistics Center, located in Dubai. I built internationalized dashboards for them in a highly secure environment. Whilst one of the apps (Al Saray) is not meant for public release, 'UAE Stat' is posited for launch in October 2024 at GITEX Global, Dubai's premier technology event.",
        ),
        12.verticalSpace,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            PortfolioImage.alSarayCountries,
            PortfolioImage.alSarayHome,
            PortfolioImage.alSarayReportDetail,
            PortfolioImage.uaeStatHome,
            PortfolioImage.uaeStatEconomy,
          ]
              .map(
                (e) => SizedBox(
                  width: 100,
                  child: Image.asset(e.path),
                ),
              )
              .toList(),
        ),
        4.verticalSpace,
        Center(
          child: Text(
            "Pictured Al Saray and UAE Stat. UI Design was from my coworker Bhavinkumar.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        20.verticalSpace,
        actionChipsRow,
        20.verticalSpace,
        pureversity,
        12.verticalSpace,
        fcsc,
        12.verticalSpace,
        const Text(
          "My main stack is Flutter, SQL, ORMs, Node, etc. and I'm currently working to learn Swift.",
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
