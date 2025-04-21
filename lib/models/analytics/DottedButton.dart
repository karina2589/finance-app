import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashedBorderButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData iconData;

  const DashedBorderButton({required this.text, required this.onPressed,required this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: MediaQuery.of(context).size.width*0.85,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: RichText(
            textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(iconData,
                  size: 20, color: Colors.black),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(
              text: text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        ),
      ),)
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)));

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}