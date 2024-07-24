import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                SemiCircleProgressIndicator(
                  progress: 1,
                  color: Color(0xFFE2E8F0),
                ),
                SemiCircleProgressIndicator(
                  progress: 0.75,
                  color: Color(0xFF1AA6B7),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: 300, child: Center(child: Text('data')))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SemiCircleProgressPainter extends CustomPainter {
  final double progress; // Progress value between 0 and 1
  final Color color;

  SemiCircleProgressPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final double angle = 180 * progress; // Convert progress to angle in degrees
    final double startAngle = math.pi; // Start angle in radians
    final double sweepAngle =
        (angle / 180) * math.pi; // Convert angle to radians
    final rect = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);
    final paint = Paint()
      ..color = color // Customize your progress indicator color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8; // Customize the stroke width

    // Draw the semi-circle progress indicator
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SemiCircleProgressIndicator extends StatefulWidget {
  final double progress;
  final Color color;

  SemiCircleProgressIndicator({required this.progress, required this.color});

  @override
  _SemiCircleProgressIndicatorState createState() =>
      _SemiCircleProgressIndicatorState();
}

class _SemiCircleProgressIndicatorState
    extends State<SemiCircleProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Color colorbg = widget.color;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Customize animation duration
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.progress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: SemiCircleProgressPainter(
            _progressAnimation.value,
            colorbg,
          ),
          child: Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
