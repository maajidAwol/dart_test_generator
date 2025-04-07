import 'package:test/test.dart';
import 'dart:convert';

import 'package:gemini_test_generator/json_processor_example.dart'; // Replace with your actual import

void main() {
  group('JsonProcessor', () {
    late JsonProcessor processor;

    setUp(() {
      processor = JsonProcessor();
    });

    group('sumValues', () {
      test('should sum values correctly with valid JSON', () {
        final jsonString = '[{"value": 1.0}, {"value": 2.5}, {"value": 3}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, 6.5);
      });

      test('should sum values correctly with integers', () {
        final jsonString = '[{"value": 1}, {"value": 2}, {"value": 3}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, 6.0);
      });

      test('should return 0 when the list is empty', () {
        final jsonString = '[]';
        final sum = processor.sumValues(jsonString);
        expect(sum, 0.0);
      });

      test('should return 0 when there are no "value" keys', () {
        final jsonString = '[{"otherKey": 1}, {"anotherKey": 2}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when the JSON is invalid', () {
        final jsonString = 'invalid json';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when a value is not a number', () {
        final jsonString = '[{"value": "string"}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when the item is not a Map', () {
        final jsonString = '[1, 2, 3]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when a "value" is null', () {
        final jsonString = '[{"value": null}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('should sum values correctly with a single object in the list', () {
        final jsonString = '[{"value": 5.0}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, 5.0);
      });

      test('should sum values correctly with negative values', () {
        final jsonString = '[{"value": -1.0}, {"value": 2.5}, {"value": -3}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, -1.5);
      });

    });

    group('multiplyValues', () {
      test('should multiply values correctly with valid JSON', () {
        final jsonString = '[{"value": 1.0}, {"value": 2.5}, {"value": 3}]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, [2.0, 5.0, 6.0]);
      });

      test('should multiply values correctly with integers', () {
        final jsonString = '[{"value": 1}, {"value": 2}, {"value": 3}]';
        final result = processor.multiplyValues(jsonString, 0.5);
        expect(result, [0.5, 1.0, 1.5]);
      });

      test('should return an empty list when the list is empty', () {
        final jsonString = '[]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, []);
      });

      test('should throw FormatException when there are no "value" keys', () {
        final jsonString = '[{"otherKey": 1}, {"anotherKey": 2}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when the JSON is invalid', () {
        final jsonString = 'invalid json';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when a value is not a number', () {
        final jsonString = '[{"value": "string"}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when the item is not a Map', () {
        final jsonString = '[1, 2, 3]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('should throw FormatException when a "value" is null', () {
        final jsonString = '[{"value": null}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('should multiply values correctly with a single object in the list', () {
        final jsonString = '[{"value": 5.0}]';
        final result = processor.multiplyValues(jsonString, 3.0);
        expect(result, [15.0]);
      });

      test('should multiply values correctly with negative values and factor', () {
        final jsonString = '[{"value": -1.0}, {"value": 2.5}, {"value": -3}]';
        final result = processor.multiplyValues(jsonString, -2.0);
        expect(result, [2.0, -5.0, 6.0]);
      });
    });
  });
}
