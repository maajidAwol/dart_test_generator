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
      test('Normal case: Valid JSON with numeric values', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20.5}, {"value": -5}]';
        const expectedValue = 25.5;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Normal case: Empty JSON array', () {
        // Arrange
        const testInput = '[]';
        const expectedValue = 0.0;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: JSON with null value', () {
        // Arrange
        const testInput = '[{"value": null}]';

        // Act & Assert
        expect(
          () => instance.sumValues(testInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with missing value key', () {
        // Arrange
        const testInput = '[{"other": 10}]';

        // Act & Assert
        expect(
          () => instance.sumValues(testInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with non-numeric value', () {
        // Arrange
        const testInput = '[{"value": "abc"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(testInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: Invalid JSON format', () {
        // Arrange
        const testInput = 'invalid json';

        // Act & Assert
        expect(
          () => instance.sumValues(testInput),
          throwsA(isA<FormatException>()),
        );
      });

      test('Normal case: JSON with zero value', () {
        // Arrange
        const testInput = '[{"value": 0}]';
        const expectedValue = 0.0;

        // Act
        final result = instance.sumValues(testInput);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: JSON with a list of negative values', () {
          // Arrange
          const testInput = '[{"value": -1}, {"value": -2}, {"value": -3}]';
          const expectedValue = -6.0;

          // Act
          final result = instance.sumValues(testInput);

          // Assert
          expect(result, closeTo(expectedValue, 0.001));
      });

      test('Edge case: JSON with a nested object instead of a value', () {
        // Arrange
        const testInput = '[{"value": {"nested": 1}}]';

        // Act & Assert
        expect(
          () => instance.sumValues(testInput),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('multiplyValues', () {
      test('Normal case: Valid JSON with numeric values and positive factor', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20.5}, {"value": -5}]';
        const factor = 2.0;
        const expectedValue = [20.0, 41.0, -10.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: Valid JSON with numeric values and negative factor', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20.5}, {"value": -5}]';
        const factor = -2.0;
        const expectedValue = [-20.0, -41.0, 10.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: Empty JSON array', () {
        // Arrange
        const testInput = '[]';
        const factor = 2.0;
        const expectedValue = <double>[];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: JSON with null value', () {
        // Arrange
        const testInput = '[{"value": null}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(testInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with missing value key', () {
        // Arrange
        const testInput = '[{"other": 10}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(testInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with non-numeric value', () {
        // Arrange
        const testInput = '[{"value": "abc"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(testInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: Invalid JSON format', () {
        // Arrange
        const testInput = 'invalid json';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(testInput, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Normal case: Factor is zero', () {
        // Arrange
        const testInput = '[{"value": 10}, {"value": 20.5}]';
        const factor = 0.0;
        const expectedValue = [0.0, 0.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: JSON values are already doubles', () {
        // Arrange
        const testInput = '[{"value": 10.0}, {"value": 20.5}]';
        const factor = 2.0;
        const expectedValue = [20.0, 41.0];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: Factor is a very large number', () {
        // Arrange
        const testInput = '[{"value": 1}]';
        const factor = 1e10;
        const expectedValue = [1e10];

        // Act
        final result = instance.multiplyValues(testInput, factor);

        // Assert
        expect(result, expectedValue);
      });
    });
  });
}
