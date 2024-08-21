import 'package:flutter/material.dart';

import 'space.dart';

enum Position { top, bottom }

class HeaderFooter extends StatelessWidget {
  const HeaderFooter({
    super.key,
    required this.child,
    this.position = Position.bottom,
  });

  final Widget child;
  final Position position;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
    );
    final gradient = LinearGradient(
      stops: const [
        0,
        1,
      ],
      colors: [
        Colors.white,
        Colors.white.withOpacity(0),
      ],
      begin: const Alignment(0, 0),
      end: Alignment.topCenter,
    );
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bodyContent = Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.78,
              alignment: Alignment.bottomCenter,
              child: RotatedBox(
                quarterTurns: 0,
                child: ShaderMask(
                  shaderCallback: (bounds) => gradient.createShader(bounds),
                  child: image,
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            24.verticalSpace,
            switch (position) {
              Position.top => viewInsets.top.verticalSpace,
              Position.bottom => viewInsets.bottom.verticalSpace,
            },
          ],
        ),
      ],
    );
    return SafeArea(
      top: position != Position.top,
      bottom: position != Position.bottom,
      child: bodyContent,
    );
  }
}
