import 'dart:math';

class GeradorNumeroAleatorio {
  static int gerarNumeroAleatorio() {
    Random numeroAleatorio = Random();
    return numeroAleatorio.nextInt(1000);
  }
}
