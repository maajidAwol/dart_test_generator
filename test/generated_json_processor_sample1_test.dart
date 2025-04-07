import 'package:test/test.dart';
import 'dart:convert';

import 'package:gemini_test_generator/json_processor_example.dart'; // Replace with your actual project and file name.  For example: 'package:json_processing/json_processor.dart';

void main() {
  group('JsonProcessor', () {
    late JsonProcessor processor;

    setUp(() {
      processor = JsonProcessor();
    });

    group('sumValues', () {
      test('Normal case: sums values correctly', () {
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30.5}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, closeTo(60.5, 0.001));
      });

      test('Normal case: sums values correctly with negative values', () {
        const jsonString = '[{"value": -10}, {"value": 20}, {"value": -30.5}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, closeTo(-20.5, 0.001));
      });

      test('Normal case: sums values correctly with zero', () {
        const jsonString = '[{"value": 10}, {"value": 0}, {"value": 30.5}]';
        final sum = processor.sumValues(jsonString);
        expect(sum, closeTo(40.5, 0.001));
      });

      test('Edge case: empty list returns 0', () {
        const jsonString = '[]';
        final sum = processor.sumValues(jsonString);
        expect(sum, 0);
      });

      test('Edge case: list with no "value" keys returns throws FormatException', () {
        const jsonString = '[{"other": 10}, {"other": 20}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('Edge case: invalid item format throws FormatException', () {
        const jsonString = '[10, 20, 30]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('Edge case: null value throws FormatException', () {
        const jsonString = '[{"value": null}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('Edge case: string value throws FormatException', () {
        const jsonString = '[{"value": "abc"}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('Edge case: boolean value throws FormatException', () {
        const jsonString = '[{"value": true}]';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

      test('Edge case: invalid JSON string throws FormatException', () {
        const jsonString = 'invalid json';
        expect(() => processor.sumValues(jsonString), throwsA(isA<FormatException>()));
      });

    });

    group('multiplyValues', () {
      test('Normal case: multiplies values correctly', () {
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30.5}]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, [20.0, 40.0, 61.0]);
      });

      test('Normal case: multiplies values correctly with negative values', () {
        const jsonString = '[{"value": -10}, {"value": 20}, {"value": -30.5}]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, [-20.0, 40.0, -61.0]);
      });

      test('Normal case: multiplies values correctly with zero', () {
        const jsonString = '[{"value": 10}, {"value": 0}, {"value": 30.5}]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, [20.0, 0.0, 61.0]);
      });

      test('Edge case: empty list returns empty list', () {
        const jsonString = '[]';
        final result = processor.multiplyValues(jsonString, 2.0);
        expect(result, []);
      });

      test('Edge case: list with no "value" keys throws FormatException', () {
        const jsonString = '[{"other": 10}, {"other": 20}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Edge case: invalid item format throws FormatException', () {
        const jsonString = '[10, 20, 30]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Edge case: null value throws FormatException', () {
        const jsonString = '[{"value": null}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Edge case: string value throws FormatException', () {
        const jsonString = '[{"value": "abc"}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Edge case: boolean value throws FormatException', () {
        const jsonString = '[{"value": true}]';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Edge case: invalid JSON string throws FormatException', () {
        const jsonString = 'invalid json';
        expect(() => processor.multiplyValues(jsonString, 2.0), throwsA(isA<FormatException>()));
      });

      test('Normal case: multiplies values correctly with factor 0', () {
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30.5}]';
        final result = processor.multiplyValues(jsonString, 0);
        expect(result, [0.0, 0.0, 0.0]);
      });

      test('Normal case: multiplies values correctly with factor -1', () {
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30.5}]';
        final result = processor.multiplyValues(jsonString, -1);
        expect(result, [-10.0, -20.0, -30.5]);
      });
    });
  });
}
