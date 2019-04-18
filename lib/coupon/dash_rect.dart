import 'package:flutter/material.dart';

class DashRect extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPaint(
      painter: PathPainter(),
    );
  }

}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color=Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0;
    Path path = Path();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return null;
  }
}