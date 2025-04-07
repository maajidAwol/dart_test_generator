import 'dart:convert';

class JsonProcessor {
  /// Sums the 'value' fields from a JSON string representing a list of objects.
  /// Throws a FormatException if the JSON structure is invalid.
  double sumValues(String jsonString) {
    final List<dynamic> list = jsonDecode(jsonString);
    double sum = 0.0;
    for (var item in list) {
      if (item is Map && item.containsKey('value')) {
        final dynamic value = item['value'];
        if (value is num) {
          sum += value.toDouble();
        } else {
          throw FormatException('Invalid value type');
        }
      } else {
        throw FormatException('Invalid item format');
      }
    }
    return sum;
  }

  /// Multiplies each 'value' in the JSON string by a given factor and returns the results.
  /// Throws a FormatException for invalid JSON structure or value types.
  List<double> multiplyValues(String jsonString, double factor) {
    final List<dynamic> list = jsonDecode(jsonString);
    final List<double> result = [];
    for (var item in list) {
      if (item is Map && item.containsKey('value')) {
        final dynamic value = item['value'];
        if (value is num) {
          result.add(value.toDouble() * factor);
        } else {
          throw FormatException('Invalid value type');
        }
      } else {
        throw FormatException('Invalid item format');
      }
    }
    return result;
  }
}
