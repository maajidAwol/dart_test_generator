import 'dart:convert';
import 'package:test/test.dart';
import 'package:gemini_test_generator/json_processor_example1.dart';

void main() {
  group('JsonProcessor', () {
    late JsonProcessor instance;

    setUp(() {
      instance = JsonProcessor();
    });

    group('sumValues', () {
      test('Normal case: sums values from a valid JSON string', () {
        // Arrange
        const jsonString = '[{"value": 1.0}, {"value": 2.5}, {"value": 3}]';
        const expectedValue = 6.5;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Normal case: sums values with negative numbers', () {
        // Arrange
        const jsonString = '[{"value": -1.0}, {"value": 2.5}, {"value": -3}]';
        const expectedValue = -1.5;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Normal case: sums values with zero', () {
        // Arrange
        const jsonString = '[{"value": 0.0}, {"value": 2.5}, {"value": 0}]';
        const expectedValue = 2.5;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Normal case: sums values with only integers', () {
        // Arrange
        const jsonString = '[{"value": 1}, {"value": 2}, {"value": 3}]';
        const expectedValue = 6.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Edge case: empty list', () {
        // Arrange
        const jsonString = '[]';
        const expectedValue = 0.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedValue, 0.001));
      });

      test('Edge case: value is null', () {
        // Arrange
        const jsonString = '[{"value": null}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: missing value key', () {
        // Arrange
        const jsonString = '[{"name": "item1"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid JSON format', () {
        // Arrange
        const invalidJsonString = '{"value": 1.0';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidJsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: value is a string', () {
        // Arrange
        const jsonString = '[{"value": "invalid"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: value is a boolean', () {
        // Arrange
        const jsonString = '[{"value": true}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

       test('Edge case: item is not a map', () {
        // Arrange
        const jsonString = '[1]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('multiplyValues', () {
      test('Normal case: multiplies values from a valid JSON string', () {
        // Arrange
        const jsonString = '[{"value": 1.0}, {"value": 2.5}, {"value": 3}]';
        const factor = 2.0;
        const expectedValue = [2.0, 5.0, 6.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values with negative numbers', () {
        // Arrange
        const jsonString = '[{"value": -1.0}, {"value": 2.5}, {"value": -3}]';
        const factor = 2.0;
        const expectedValue = [-2.0, 5.0, -6.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values with zero', () {
        // Arrange
        const jsonString = '[{"value": 0.0}, {"value": 2.5}, {"value": 0}]';
        const factor = 2.0;
        const expectedValue = [0.0, 5.0, 0.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Normal case: multiplies values with only integers', () {
        // Arrange
        const jsonString = '[{"value": 1}, {"value": 2}, {"value": 3}]';
        const factor = 2.0;
        const expectedValue = [2.0, 4.0, 6.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: empty list', () {
        // Arrange
        const jsonString = '[]';
        const factor = 2.0;
        const expectedValue = <double>[];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: value is null', () {
        // Arrange
        const jsonString = '[{"value": null}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: missing value key', () {
        // Arrange
        const jsonString = '[{"name": "item1"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: invalid JSON format', () {
        // Arrange
        const invalidJsonString = '{"value": 1.0';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidJsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: value is a string', () {
        // Arrange
        const jsonString = '[{"value": "invalid"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: value is a boolean', () {
        // Arrange
        const jsonString = '[{"value": true}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: factor is negative', () {
        // Arrange
        const jsonString = '[{"value": 1.0}]';
        const factor = -2.0;
        const expectedValue = [-2.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: factor is zero', () {
        // Arrange
        const jsonString = '[{"value": 1.0}]';
        const factor = 0.0;
        const expectedValue = [0.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedValue);
      });

      test('Edge case: item is not a map', () {
        // Arrange
        const jsonString = '[1]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
