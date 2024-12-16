import 'package:flutter/material.dart';

class CizimTahtasi extends StatefulWidget {
  const CizimTahtasi({super.key});

  @override
  State<CizimTahtasi> createState() => _CizimTahtasiState();
}

class _CizimTahtasiState extends State<CizimTahtasi> {
  final noktalar = <Offset?>[];

  var resimMatrisi = List<List<int>>.generate(
    360,
    (i) => List<int>.generate(360, (j) => 0),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  noktalar.clear(); // Clear the sketch
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                resimMatrisi = List<List<int>>.generate(
                  360,
                  (i) => List<int>.generate(360, (j) => 0),
                );
                for (final nokta in noktalar) {
                  if (nokta != null) {
                    /*  print(
                      "nokta.dx: ${nokta.dx.toInt()} nokta.dy: ${nokta.dy.toInt()}",
                    ); */
                    resimMatrisi[nokta.dy.toInt()][nokta.dx.toInt()] = 1;
                  }
                }
                // resim matrisi to 36x36 by summing up the 10x10 blocks
                final yeniResimMatrisi = List<List<int>>.generate(
                  36,
                  (i) => List<int>.generate(36, (j) => 0),
                );
                for (int i = 0; i < 36; i++) {
                  for (int j = 0; j < 36; j++) {
                    for (int k = 0; k < 10; k++) {
                      for (int l = 0; l < 10; l++) {
                        yeniResimMatrisi[i][j] +=
                            resimMatrisi[i * 10 + k][j * 10 + l];
                      }
                    }
                  }
                }
                // print the 36x36 matrix
                for (int i = 0; i < 36; i++) {
                  print("$i.\t${yeniResimMatrisi[i]}");
                }
              },
            ),
          ],
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
                    /* noktalar.add(nokta);
                    setState(() {}); */
                    // add 10 points for each pixel
                    for (int i = 0; i < 10; i++) {
                      for (int j = 0; j < 10; j++) {
                        noktalar.add(Offset(
                          nokta.dx + i.toDouble(),
                          nokta.dy + j.toDouble(),
                        ));
                      }
                    }
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
      ..strokeWidth = 1;

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
