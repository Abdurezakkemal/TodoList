import 'package:flutter/material.dart';

class AnimatedCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const AnimatedCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AnimatedCheckboxState createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isChecked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      if (widget.isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isChecked);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: widget.isChecked ? Theme.of(context).primaryColor : Colors.transparent,
              border: Border.all(
                color: widget.isChecked ? Theme.of(context).primaryColor : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomPaint(
              painter: CheckmarkPainter(_animation.value),
            ),
          );
        },
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // First line of the checkmark
    path.moveTo(size.width * 0.2, size.height * 0.5);
    final firstLineProgress = (progress * 2).clamp(0.0, 1.0);
    path.lineTo(
      size.width * 0.2 + (size.width * 0.25 * firstLineProgress),
      size.height * 0.5 + (size.height * 0.25 * firstLineProgress),
    );

    // Second line of the checkmark
    if (progress > 0.5) {
      final secondLineProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
      path.lineTo(
        size.width * 0.45 + (size.width * 0.35 * secondLineProgress),
        size.height * 0.75 - (size.height * 0.45 * secondLineProgress),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
