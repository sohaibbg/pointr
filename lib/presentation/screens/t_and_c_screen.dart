import 'package:flutter/material.dart';

import '../../config/my_theme.dart';
import '../components/header_footer.dart';
import '../components/space.dart';

class TAndCScreen extends StatelessWidget {
  const TAndCScreen({super.key});

  static const data = [
    "Welcome to pointr. By downloading or using the App, you agree to comply with and be bound by the following terms and conditions. Please read them carefully. If you do not agree with these terms, do not use the app.",
    "pointr does not collect, store, or share any personal information from its users.",
    "You agree to use the App in a manner consistent with all applicable laws and regulations. The App is provided \"as is\" without any warranties, whether express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement.",
    "pointr is not affiliated with People's Bus Service, the Government of Sindh or other relevant agencies.\n\nGiven routes may be subject to change and inaccuracy. Please confirm from other sources before planning your route.\n\nPlease download the official People's Bus Service App for official information and for using the digital ticketing system.",
    "In no event shall pointr be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of data, use, or profits, arising out of or in connection with your use of the App.",
    "We reserve the right to modify these terms and conditions at any time. Any changes will be posted within the App and will become effective immediately upon posting. Your continued use of the App after any such changes constitutes your acceptance of the new terms.",
    "If you have any questions about these Terms and Conditions, please contact us at sohaibbg@gmail.com",
    "The route suggestions provided by this app are generated by an algorithm that is still being refined. Please note that the algorithm does not yet support split-route journeys (e.g., taking multiple buses for the optimal route), and the recommendations may have room for improvement.",
    "By using this app, you are bound by Google's Terms of Use and Privacy Policy as defined here: https://cloud.google.com/maps-platform/terms/?hl=en https://www.google.com/policies/privacy/",
  ];

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .displayMedium
        ?.copyWith(color: Colors.grey.shade800);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Terms and Conditions",
          style: titleStyle,
          textAlign: TextAlign.start,
        ),
        20.verticalSpace,
        Text(
          data.join('\n\n'),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 200,
                ),
                children: [
                  text,
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
