import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";

class SharePriceChart extends StatelessWidget {
  const SharePriceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "Share Price History",
      action: TextButton(
        onPressed: () {},
        child: const Text(
          "View Details",
          style: TextStyle(color: Color(0xFF4A90D9), fontSize: 13),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Simple chart visualization
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _LineChartPainter(),
              child: Container(),
            ),
          ),

          const SizedBox(height: 20),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ChartLegendItem(
                label: "Initial",
                value: "\$100",
                color: Colors.white.withOpacity(0.5),
              ),
              _ChartLegendItem(
                label: "Current",
                value: "\$125",
                color: const Color(0xFF4A90D9),
              ),
              _ChartLegendItem(
                label: "Change",
                value: "+25%",
                color: const Color(0xFF2ECC71),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  const _ChartLegendItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
}

// Simple line chart painter
class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sample data points (normalized 0-1)
    final dataPoints = [
      Offset(0, 0.8),
      Offset(0.15, 0.75),
      Offset(0.3, 0.7),
      Offset(0.45, 0.65),
      Offset(0.6, 0.5),
      Offset(0.75, 0.4),
      Offset(0.9, 0.3),
      Offset(1.0, 0.2),
    ];

    // Convert to actual coordinates
    final points = dataPoints.map((point) {
      return Offset(point.dx * size.width, point.dy * size.height);
    }).toList();

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4A90D9).withOpacity(0.3),
          const Color(0xFF4A90D9).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(points.first.dx, size.height);
    path.lineTo(points.first.dx, points.first.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      path.quadraticBezierTo(
        current.dx,
        current.dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }

    path.lineTo(points.last.dx, points.last.dy);
    path.lineTo(points.last.dx, size.height);
    path.close();
    canvas.drawPath(path, gradientPaint);

    // Draw line
    final linePaint = Paint()
      ..color = const Color(0xFF4A90D9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      linePath.quadraticBezierTo(
        current.dx,
        current.dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }
    linePath.lineTo(points.last.dx, points.last.dy);

    canvas.drawPath(linePath, linePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = const Color(0xFF4A90D9)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(
        point,
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
