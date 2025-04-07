import 'dart:convert';
import 'package:test/test.dart';
import 'package:gemini_test_generator/json_processor_example.dart';

void main() {
  group('JsonProcessor', () {
    late JsonProcessor instance;

    setUp(() {
      instance = JsonProcessor();
    });

    group('sumValues', () {
      test('Normal case: sums the values from a valid JSON string', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20}, {"value": 30.5}]';
        const expectedValue = 60.5;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Normal case: sums values when the list is empty', () {
        // Arrange
        const testInput = '[]';
        const expectedValue = 0.0;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: sums values when the value is 0', () {
        // Arrange
        const testInput = '[{"value": 0}, {"value": 0}]';
        const expectedValue = 0.0;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: sums values with negative values', () {
        // Arrange
        const testInput = '[{"value": -10}, {"value": 20}]';
        const expectedValue = 10.0;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: sums values with very large numbers', () {
        // Arrange
        const testInput = '[{"value": 1e10}, {"value": 1e10}]';
        const expectedValue = 2e10;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Edge case: invalid JSON string', () {
        // Arrange
        const invalidInput = 'invalid json';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: missing "value" key', () {
        // Arrange
        const invalidInput = '[{"other": 10}]';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid value type (string)', () {
        // Arrange
        const invalidInput = '[{"value": "abc"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid value type (null)', () {
        // Arrange
        const invalidInput = '[{"value": null}]';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidInput),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('multiplyValues', () {
      test('Normal case: multiplies values by a factor', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20}]';
        const factor = 2.0;
        const expectedValue = [20.0, 40.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values by a factor when the list is empty', () {
        // Arrange
        const testInput = '[]';
        const factor = 2.0;
        const expectedValue = <double>[];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values by a factor of 0', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20}]';
        const factor = 0.0;
        const expectedValue = [0.0, 0.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values by a negative factor', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20}]';
        const factor = -2.0;
        const expectedValue = [-20.0, -40.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: invalid JSON string', () {
        // Arrange
        const invalidInput = 'invalid json';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: missing "value" key', () {
        // Arrange
        const invalidInput = '[{"other": 10}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid value type (string)', () {
        // Arrange
        const invalidInput = '[{"value": "abc"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid value type (null)', () {
        // Arrange
        const invalidInput = '[{"value": null}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidInput, factor),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
