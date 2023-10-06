import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bulb(),
    );
  }
}

class Bulb extends StatefulWidget {
  const Bulb({super.key});

  @override
  State<Bulb> createState() => _BulbState();
}

class _BulbState extends State<Bulb> {
  bool on = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: CustomPaint(
                size: const Size(300, 500),
                painter: BulbPainter(on: on),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => on = !on),
              child: Container(
                height: 300,
                alignment: Alignment.center,
                color: Colors.white,
                child: CustomPaint(
                  size: const Size(100, 200),
                  painter: SwitchPainter(on: on),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BulbPainter extends CustomPainter {
  final bool on;
  BulbPainter({required this.on});

  @override
  void paint(Canvas canvas, Size size) {
    Paint bulbPaint = Paint()..color = Colors.white;
    Paint shinePaint = Paint()
      ..color = Colors.yellow.shade300
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawLine(
        Offset(size.width * 0.5, size.width * 0.8),
        Offset(size.width * 0.5, size.height * 2),
        Paint()
          ..color = Colors.grey.shade700
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.015);

    if (on) {
      canvas.drawCircle(Offset(size.width * 0.5, size.width * 0.37),
          size.width * 0.2, shinePaint);
      canvas.drawCircle(
          Offset(size.width * 0.5, size.width * 0.37),
          size.width * 0.2,
          shinePaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30));
    }

    canvas.drawCircle(Offset(size.width * 0.5, size.width * 0.37),
        size.width * 0.2, bulbPaint);

    Path bulbBottomPath = Path()
      ..moveTo(size.width * 0.4, size.width * 0.625)
      ..quadraticBezierTo(size.width * 0.4, size.width * 0.55,
          size.width * 0.35, size.width * 0.5)
      ..lineTo(size.width * 0.65, size.width * 0.5)
      ..quadraticBezierTo(size.width * 0.6, size.width * 0.55, size.width * 0.6,
          size.width * 0.625)
      ..close();

    canvas.drawPath(bulbBottomPath, bulbPaint);

    for (double i = 0.65; i < 0.8; i += 0.05) {
      canvas.drawLine(
          Offset(size.width * 0.4, size.width * i),
          Offset(size.width * 0.6, size.width * i),
          Paint()
            ..color = Colors.grey.shade800
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.05
            ..strokeCap = StrokeCap.round);
      canvas.drawLine(
          Offset(size.width * 0.4, size.width * (i + 0.025)),
          Offset(size.width * 0.6, size.width * (i + 0.025)),
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.005);
    }

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width * 0.5, size.width * 0.775),
            width: size.width * 0.15,
            height: size.width * 0.1),
        0 * pi / 180,
        180 * pi / 180,
        true,
        Paint()..color = Colors.grey.shade800);
  }

  @override
  bool shouldRepaint(BulbPainter oldDelegate) => on != oldDelegate.on;
}

class SwitchPainter extends CustomPainter {
  final bool on;
  SwitchPainter({required this.on});

  @override
  void paint(Canvas canvas, Size size) {
    Paint strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    Paint fillPaint = Paint()..color = Colors.black;

    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.1),
        size.width * 0.07, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9),
        size.width * 0.07, fillPaint);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: center, width: size.width, height: size.height),
            Radius.circular(size.width * 0.05)),
        strokePaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: center,
                width: size.width * 0.65,
                height: size.height * 0.6),
            Radius.circular(size.width * 0.05)),
        strokePaint);

    //main switch
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: center,
                width: size.width * 0.45,
                height: size.height * 0.45),
            Radius.circular(size.width * 0.05)),
        strokePaint);

    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * (on ? 0.47 : 0.37)),
        size.width * 0.07,
        strokePaint);

    canvas.drawLine(
        Offset(size.width * 0.5, size.height * (on ? 0.6 : 0.5)),
        Offset(size.width * 0.5, size.height * (on ? 0.68 : 0.58)),
        strokePaint);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(
                size.width * 0.5, size.height * (on ? (1 - 0.68) : 0.68)),
            width: size.width * 0.45,
            height: size.height * 0.1),
        fillPaint);
  }

  @override
  bool shouldRepaint(SwitchPainter oldDelegate) => on != oldDelegate.on;
}
