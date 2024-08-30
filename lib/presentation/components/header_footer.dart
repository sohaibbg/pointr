import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
    );
    final gradient = LinearGradient(
      stops: const [0, 1],
      colors: [
        Colors.white,
        Colors.white.withOpacity(0),
      ],
      begin: Alignment.center,
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

class HeaderBackdrop extends StatelessWidget {
  const HeaderBackdrop({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          child,
        ],
      );
}
