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
      test('Normal case: sums the values from a valid JSON string', () {
        // Arrange
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30}]';
        const expectedSum = 60.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, expectedSum);
      });

      test('Normal case: sums values including decimal numbers', () {
        // Arrange
        const jsonString = '[{"value": 10.5}, {"value": 20.25}, {"value": 30.75}]';
        const expectedSum = 61.5;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, closeTo(expectedSum, 0.001));
      });

      test('Normal case: sums values including negative numbers', () {
        // Arrange
        const jsonString = '[{"value": -10}, {"value": 20}, {"value": -5}]';
        const expectedSum = 5.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, expectedSum);
      });

      test('Normal case: sums values when JSON contains additional fields', () {
        // Arrange
        const jsonString = '[{"value": 10, "extra": "data"}, {"value": 20, "other": 123}]';
        const expectedSum = 30.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, expectedSum);
      });

      test('Edge case: empty JSON list returns 0', () {
        // Arrange
        const jsonString = '[]';
        const expectedSum = 0.0;

        // Act
        final result = instance.sumValues(jsonString);

        // Assert
        expect(result, expectedSum);
      });

      test('Edge case: JSON with no "value" fields returns 0', () {
        // Arrange
        const jsonString = '[{"name": "item1"}, {"name": "item2"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with null "value" returns FormatException', () {
        // Arrange
        const jsonString = '[{"value": null}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with invalid "value" type (string) returns FormatException', () {
        // Arrange
        const jsonString = '[{"value": "invalid"}]';

        // Act & Assert
        expect(
          () => instance.sumValues(jsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: Invalid JSON format throws FormatException', () {
        // Arrange
        const invalidJsonString = 'invalid json';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidJsonString),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with an item that is not a Map throws a FormatException', () {
        // Arrange
        const invalidJsonString = '[1, 2, 3]';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidJsonString),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('multiplyValues', () {
      test('Normal case: multiplies values from a valid JSON string by a factor', () {
        // Arrange
        const jsonString = '[{"value": 10}, {"value": 20}, {"value": 30}]';
        const factor = 2.0;
        const expectedResult = [20.0, 40.0, 60.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedResult);
      });

      test('Normal case: multiplies values including decimal numbers', () {
        // Arrange
        const jsonString = '[{"value": 10.5}, {"value": 20.25}]';
        const factor = 0.5;
        const expectedResult = [5.25, 10.125];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result[0], closeTo(expectedResult[0], 0.001));
        expect(result[1], closeTo(expectedResult[1], 0.001));
      });

      test('Normal case: multiplies values including negative numbers', () {
        // Arrange
        const jsonString = '[{"value": -10}, {"value": 20}]';
        const factor = 3.0;
        const expectedResult = [-30.0, 60.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedResult);
      });

      test('Normal case: multiplies values when JSON contains additional fields', () {
        // Arrange
        const jsonString = '[{"value": 10, "extra": "data"}, {"value": 20, "other": 123}]';
        const factor = 1.5;
        const expectedResult = [15.0, 30.0];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedResult);
      });

      test('Edge case: empty JSON list returns an empty list', () {
        // Arrange
        const jsonString = '[]';
        const factor = 2.0;
        const expectedResult = <double>[];

        // Act
        final result = instance.multiplyValues(jsonString, factor);

        // Assert
        expect(result, expectedResult);
      });

      test('Edge case: JSON with no "value" fields throws FormatException', () {
        // Arrange
        const jsonString = '[{"name": "item1"}, {"name": "item2"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with null "value" throws FormatException', () {
        // Arrange
        const jsonString = '[{"value": null}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with invalid "value" type (string) throws FormatException', () {
        // Arrange
        const jsonString = '[{"value": "invalid"}]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(jsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: Invalid JSON format throws FormatException', () {
        // Arrange
        const invalidJsonString = 'invalid json';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidJsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });

      test('Edge case: JSON with an item that is not a Map throws a FormatException', () {
        // Arrange
        const invalidJsonString = '[1, 2, 3]';
        const factor = 2.0;

        // Act & Assert
        expect(
          () => instance.multiplyValues(invalidJsonString, factor),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
