extension FormatQuantity on double {
  String formatQuantity(String unit) {
    return '${this.floor().toDouble() == this ? this.floor() : this.toStringAsFixed(1)} $unit${this == 1 ? '' : 's'}';
  }
}
