import 'dart:math' as math;

class Imc {
  final double weight;
  final double height;

  Imc({required this.weight, required this.height});

  double get imc {
    var result = weight / math.pow(height, 2);
    result = result * 100;
    return result.roundToDouble() / 100;
  }
}
