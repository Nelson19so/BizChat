
extension CapitalizeString on String {
  String toCapitalized() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}