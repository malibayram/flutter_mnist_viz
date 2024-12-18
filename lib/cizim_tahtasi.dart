import 'package:flutter/material.dart';

class CizimTahtasi extends StatefulWidget {
  const CizimTahtasi({super.key, required this.onImageUpdated});

  // a function return List<int> to get the image matrix
  final Function(List<double>) onImageUpdated;

  @override
  State<CizimTahtasi> createState() => _CizimTahtasiState();
}

class _CizimTahtasiState extends State<CizimTahtasi> {
  final noktalar = <Offset?>[];

  var resimMatrisi = <List<int>>[];
  var yeniResimMatrisi = List<List<double>>.generate(
    28,
    (i) => List<double>.generate(28, (j) => 0.0),
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
                noktalar.clear(); // Clear the sketch
                yeniResimMatrisi = List<List<double>>.generate(
                  28,
                  (i) => List<double>.generate(28, (j) => 0),
                );
                widget.onImageUpdated(
                  yeniResimMatrisi.expand((e) => e).toList(),
                );

                setState(() {});
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
                      nokta.dx <= (renderBox.size.width - 48) &&
                      nokta.dy <= (renderBox.size.height - 48)) {
                    /* noktalar.add(nokta);
                    setState(() {}); */
                    // add 10 points for each pixel
                    for (int i = 0; i < 11; i++) {
                      for (int j = 0; j < 11; j++) {
                        noktalar.add(Offset(
                          nokta.dx + i.toDouble(),
                          nokta.dy + j.toDouble(),
                        ));
                      }
                    }
                    resimMatrisi = List<List<int>>.generate(
                      312,
                      (i) => List<int>.generate(312, (j) => 0),
                    );
                    for (final nokta in noktalar) {
                      if (nokta != null &&
                          nokta.dx >= 0 &&
                          nokta.dy >= 0 &&
                          nokta.dx <= 312 &&
                          nokta.dy <= 312) {
                        /*  print(
                      "nokta.dx: ${nokta.dx.toInt()} nokta.dy: ${nokta.dy.toInt()}",
                    ); */
                        resimMatrisi[nokta.dy.toInt()][nokta.dx.toInt()] = 1;
                      }
                    }
                    // resim matrisi to 36x36 by summing up the 10x10 blocks
                    yeniResimMatrisi = List<List<double>>.generate(
                      28,
                      (i) => List<double>.generate(28, (j) => 0),
                    );
                    for (int i = 0; i < 28; i++) {
                      for (int j = 0; j < 28; j++) {
                        for (int k = 0; k < 11; k++) {
                          for (int l = 0; l < 11; l++) {
                            yeniResimMatrisi[i][j] +=
                                resimMatrisi[i * 11 + k][j * 11 + l];
                          }
                        }
                        yeniResimMatrisi[i][j] /= 121;
                      }
                    }

                    widget.onImageUpdated(
                      yeniResimMatrisi.expand((e) => e).toList(),
                    );

                    setState(() {});
                  }
                },
                onPanEnd: (details) {
                  noktalar.add(null);
                  setState(() {}); // Rebuild the widget
                },
                child: CustomPaint(
                  size: const Size(312, 312),
                  painter: _CizimAlani(noktalar),
                  child: Container(
                    color: const Color(0xfff596ff),
                    width: 312,
                    height: 312,
                    child: Column(
                      children: [
                        for (int i = 0; i < 28; i++)
                          Expanded(
                            child: Row(
                              children: [
                                for (int j = 0; j < 28; j++)
                                  Expanded(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      color: yeniResimMatrisi[i][j] == 0
                                          ? Colors.transparent
                                          : Colors.yellow,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
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
