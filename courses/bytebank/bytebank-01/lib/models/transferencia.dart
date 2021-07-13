class Transferencia {
  final double value;
  final int numeroConta;

  Transferencia(this.value, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{value: $value, numeroConta: $numeroConta}';
  }
}
