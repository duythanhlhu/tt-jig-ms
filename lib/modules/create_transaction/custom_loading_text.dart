import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomLoadingText extends StatefulWidget {
  const CustomLoadingText({super.key, required this.message});

  final String message;

  @override
  State<CustomLoadingText> createState() => _CustomLoadingTextState();
}

class _CustomLoadingTextState extends State<CustomLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(); // Loop the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var strings = "${widget.message} ...".split("");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              children: List.generate(strings.length, (index) {
                final progress = (_controller.value - (index / strings.length))
                    .abs();
                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                return Opacity(
                  opacity: opacity,
                  child: Text(
                    strings[index],
                    style: primaryTextStyle(
                      size: 20,
                      weight: .bold,
                      color: Colors.green,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
