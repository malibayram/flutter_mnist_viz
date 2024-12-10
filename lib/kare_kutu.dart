import 'package:flutter/material.dart';

class KareKutu extends StatelessWidget {
  const KareKutu({super.key, this.percentage = 0.5, this.width = 100});

  final double percentage;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(2),
          child: Container(
            width: width - 4,
            height: (width - 4) * percentage,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                bottom: const Radius.circular(4),
                top: Radius.circular(
                    (width - 4) * percentage < (width - 4) ? 0 : 4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
