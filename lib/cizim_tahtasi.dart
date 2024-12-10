import 'package:flutter/material.dart';

class CizimTahtasi extends StatefulWidget {
  const CizimTahtasi({super.key});

  @override
  State<CizimTahtasi> createState() => _CizimTahtasiState();
}

class _CizimTahtasiState extends State<CizimTahtasi> {
  final noktalar = <Offset?>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              noktalar.clear(); // Clear the sketch
            });
          },
        ),
        Expanded(
          child: Container(
            color: Colors.grey,
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final renderBox = context.findRenderObject() as RenderBox;

                  final nokta = details.localPosition;

                  if (nokta.dx >= 0 &&
                      nokta.dy >= 0 &&
                      nokta.dx <= renderBox.size.width &&
                      nokta.dy <= renderBox.size.height) {
                    noktalar.add(nokta);
                    setState(() {});
                  }
                },
                onPanEnd: (details) {
                  noktalar.add(null);
                  setState(() {}); // Rebuild the widget
                },
                child: CustomPaint(
                  painter: _CizimAlani(noktalar),
                  child: const SizedBox(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CizimAlani extends CustomPainter {
  final List<Offset?> noktalar;

  _CizimAlani(this.noktalar);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < noktalar.length - 1; i++) {
      if (noktalar[i] != null && noktalar[i + 1] != null) {
        canvas.drawLine(noktalar[i]!, noktalar[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CizimAlani oldDelegate) {
    return true;
  }
}
