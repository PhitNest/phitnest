export 'validators.dart';

extension FormatQuantity on double {
  /**
   * This will return a rounded string version of this [double] with [unit] 
   * appended as the units of measurement. 
   * 
   * Examples:    1.2.formatQuantity('mile') == '1.2 miles'
   *              1.273532.formatQuantity('inch') == '1.3 inchs'
   *              1.0.formatQuantity('meter') == '1 meter'
   *              2.0.formatQuantity('cm') == '2 cms'         
   */
  String formatQuantity(String unit) {
    return '${this.floor().toDouble() == this ? this.floor() : this.toStringAsFixed(1)} $unit${this == 1 ? '' : 's'}';
  }
}
