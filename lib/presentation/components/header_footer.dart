import 'package:flutter/material.dart';

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
    final imgBg = DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.78,
        alignment: Alignment.bottomCenter,
        child: ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: RotatedBox(
            quarterTurns: 2,
            child: image,
          ),
        ),
      ),
    );
    final bodyContent = Stack(
      children: [
        Positioned.fill(
          child: imgBg,
        ),
        child,
      ],
    );
    return bodyContent;
  }
}
