# 🧪 Dart Test Generator

A command-line tool that automatically generates comprehensive unit tests for Dart classes using the Gemini AI API. This tool analyzes your Dart code and creates well-structured, meaningful tests following best practices.

## 📋 Features

- 🤖 AI-powered test generation
- 📝 Follows Dart testing best practices
- 🎯 Generates tests for all public methods
- ✨ Handles edge cases and error conditions
- 🔄 Automatic import management
- 📦 Automatic dependency setup

## 🚀 Getting Started

### Prerequisites

- Dart SDK (version 2.12.0 or higher)
- A Gemini API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/dart_test_generator.git
cd dart_test_generator
```

2. Install dependencies:
```bash
dart pub get
```

3. Set up your Gemini API key:
   - Open `bin/gemini_test_generator.dart`
   - Replace the `geminiApiKey` constant with your actual API key:
```dart
const String geminiApiKey = 'your-api-key-here';
```

## 💻 Usage

1. Run the generator:
```bash
dart run bin/gemini_test_generator.dart
```

2. Enter the path to your source file when prompted. The tool comes with a default example:

[Screenshot of the file path prompt and input]

3. The tool will automatically:
   - Generate comprehensive tests
   - Create a test file in the `test` directory
   - Add necessary dependencies
   - Run `dart pub get`

[Screenshot of the generation process]

4. Run the generated tests:
```bash
dart test test/generated_json_processor_example_test.dart
```

Output:
```
Building package executable... (1.5s)
Built test:test.
00:00 +19: All tests passed!
```

## 📝 Example

### Input: Default Example File
```dart
// lib/json_processor_example.dart
class JsonProcessor {
  double sumValues(String jsonString) {
    // Implementation
  }
  
  List<double> multiplyValues(String jsonString, double factor) {
    // Implementation
  }
}
```

### Output: Generated Test File
```dart
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
      test('Normal case: sums values from a valid JSON string', () {
        // Arrange
        const jsonString = '[{"value": 1.0}, {"value": 2.5}, {"value": 3}]';
        const expectedValue = 6.5;

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

      test('Edge case: invalid JSON format', () {
        // Arrange
        const invalidJsonString = '{"value": 1.0';

        // Act & Assert
        expect(
          () => instance.sumValues(invalidJsonString),
          throwsA(isA<FormatException>()),
        );
      });
      // ... more tests
    });
    // ... more groups
  });
}
```

## 🎯 Test Coverage

The generated tests include:

- ✅ Normal cases with valid inputs
- 🔄 Edge cases (empty lists, null values)
- ❌ Error conditions (invalid JSON, wrong types)
- 🎯 Boundary values (zero, negative numbers)
- 📊 Type checking (strings, booleans, null)
- 🧮 Numerical precision tests

## 📚 Generated Test Structure

Each test file follows a consistent structure:

1. **Imports**: Automatically managed based on your package
2. **Main Group**: Named after the class being tested
3. **Setup**: Instance creation in `setUp`
4. **Method Groups**: Separate group for each method
5. **Test Cases**:
   - Normal cases with descriptive names
   - Edge cases with expected exceptions
   - Comprehensive error handling

## ⚙️ Configuration

The tool automatically:

- Creates a `test` directory if needed
- Adds test dependencies to `pubspec.yaml`
- Manages imports correctly
- Handles package names dynamically

## 🐛 Known Issues

- Currently supports single class per file
- Requires proper JSON structure for default example
- API key must be set manually

## 🔜 Future Improvements

- [ ] Support for multiple classes per file
- [ ] Custom test template configuration
- [ ] Integration test generation
- [ ] Test coverage reporting
- [ ] Custom naming conventions
- [ ] Environment variable for API key

## 📞 Support

If you have any questions or run into issues, please [open an issue](https://github.com/yourusername/dart_test_generator/issues).

## 🙏 Acknowledgments

- Powered by Google's Gemini AI
- Built with Dart
- Inspired by best practices in testing

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
