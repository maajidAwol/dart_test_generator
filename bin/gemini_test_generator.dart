import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

/// Replace with your actual Gemini API key.
const String geminiApiKey = 'gemini_api_key';

/// Get user input with a default value shown
String? promptUserWithDefault(String message, String defaultValue) {
  stdout.write('$message [$defaultValue]: ');
  final input = stdin.readLineSync();
  return input?.isEmpty == true ? defaultValue : input;
}

Future<void> main() async {
  print('\n🧪 Dart Test Generator\n');

  // Get the file path with default suggestion
  final sourceFilePath =
      promptUserWithDefault(
        'Enter path to source file',
        'lib/json_processor_example.dart (default example enter to continue)',
      )!;

  String actualSourcePath = sourceFilePath;
  String sourceFileName;

  // Handle the file path
  if (sourceFilePath.contains('json_processor_example.dart')) {
    actualSourcePath = 'lib/json_processor_example.dart';
    sourceFileName = 'json_processor_example';
    print('\n📌 Using default example file');
  } else {
    if (!File(sourceFilePath).existsSync()) {
      print('\n❌ File not found: $sourceFilePath');
      print('Please ensure the file exists and try again.');
      return;
    }
    sourceFileName = sourceFilePath.split('/').last.replaceAll('.dart', '');
  }

  try {
    // Read the source code
    final codeSnippet = await File(actualSourcePath).readAsString();
    print('\n🔄 Generating tests for: $actualSourcePath');

    final generatedTests = await generateTests(codeSnippet);
    final processedTests = processGeneratedTests(
      generatedTests,
      actualSourcePath,
    );

    // Create test directory if it doesn't exist
    final testDir = Directory('test');
    if (!testDir.existsSync()) {
      testDir.createSync();
    }

    // Generate the test file path
    final testFilePath = 'test/generated_${sourceFileName}_test.dart';
    await File(testFilePath).writeAsString(processedTests);

    // Update pubspec.yaml with required dependencies
    await updatePubspecWithTestDependencies();

    print('\n🔧 Installing dependencies...');
    final result = await Process.run('dart', ['pub', 'get']);
    if (result.exitCode != 0) {
      throw Exception('Failed to install dependencies');
    }

    // Print success message and instructions
    printSuccessMessage(testFilePath);
  } catch (e) {
    print('\n❌ Error: ${e.toString().replaceAll('Exception: ', '')}');
    print('Please try again or report this issue if it persists.');
  }
}

/// Print success message and instructions
void printSuccessMessage(String testFilePath) {
  print('''

✅ Test Generation Complete!

📝 Generated test file:
   $testFilePath

💡 Run your tests:
   • Single test file:
     dart test $testFilePath

   • All project tests:
     dart test

📚 Documentation:
   • https://dart.dev/guides/testing
   • https://pub.dev/packages/test

Happy Testing! 🚀
''');
}

Future<String> generateTests(String codeSnippet) async {
  final prompt = '''
Generate comprehensive Dart tests for the following code. Follow this exact template structure:

```dart
void main() {
  group('ClassNameUnderTest', () {
    late ClassNameUnderTest instance;

    setUp(() {
      instance = ClassNameUnderTest();
    });

    group('methodName', () {
      test('Normal case: description of what is being tested', () {
        // Arrange - prepare test data
        const testInput = 'test data';
        
        // Act - call the method being tested
        final result = instance.methodName(testInput);
        
        // Assert - verify the results
        expect(result, expectedValue);
      });

      test('Edge case: description of edge case', () {
        // Arrange
        const invalidInput = 'invalid data';
        
        // Act & Assert
        expect(
          () => instance.methodName(invalidInput),
          throwsA(isA<ExpectedExceptionType>()),
        );
      });
    });
  });
}
```

Important Guidelines:
1. DO NOT include any import statements - they will be added automatically
2. Replace ClassNameUnderTest with the actual class name from the code
3. Create separate test groups for each public method
4. Follow the Arrange-Act-Assert pattern in test cases
5. Use descriptive test names:
   - Normal cases start with "Normal case: "
   - Edge cases start with "Edge case: "
6. For floating-point comparisons, use: expect(actual, closeTo(expected, 0.001))
7. For error cases, use the correct exception types:
   - JSON parsing errors: throwsA(isA<FormatException>())
   - Type errors: throwsA(isA<TypeError>())
8. Use const for all test data where possible
9. Include tests for:
   - Normal input cases
   - Edge cases (empty, null, invalid types)
   - Error conditions
   - Boundary values
10. ALWAYS use the 'instance' variable created in setUp to call methods, never use any other variable name

Here is the code to test:

$codeSnippet

Generate tests that will compile and run without errors, following these guidelines strictly. Do not include any imports or package references - these will be handled automatically. Always use the 'instance' variable to call methods.
''';

  // Replace with the correct Gemini API endpoint and parameters.
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
  );
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  } else {
    throw Exception('Failed to generate tests: ${response.body}');
  }
}

/// Process the generated test code to ensure correct imports and syntax
String processGeneratedTests(String generatedCode, String sourceFilePath) {
  // Extract the package name from pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();

  // Default package name if we can't extract it
  String packageName = 'gemini_test_generator';

  // Try to extract the package name from pubspec.yaml
  final nameMatch = RegExp(r'name:\s+([^\s]+)').firstMatch(pubspecContent);
  if (nameMatch != null && nameMatch.group(1) != null) {
    packageName = nameMatch.group(1)!;
  }

  // Get the relative path from lib to the source file
  String relativePath = sourceFilePath;
  if (sourceFilePath.startsWith('lib/')) {
    relativePath = sourceFilePath.substring(4); // Remove 'lib/' prefix
  }
  relativePath = relativePath.replaceAll('.dart', ''); // Remove .dart extension

  // Create the standard imports block
  final requiredImports = [
    "import 'dart:convert';",
    "import 'package:test/test.dart';",
    "import 'package:$packageName/$relativePath.dart';",
  ];

  // Process the code
  String processedCode = generatedCode;

  // Handle markdown code blocks
  if (processedCode.contains('```dart')) {
    final codeMatch = RegExp(
      r'```dart\n([\s\S]*?)```',
    ).firstMatch(processedCode);
    if (codeMatch != null && codeMatch.group(1) != null) {
      processedCode = codeMatch.group(1)!;
    }
  }

  // Remove all existing imports
  processedCode =
      processedCode
          // Remove standard imports
          .replaceAll(RegExp(r'import\s+[^;]+;[\s\n]*'), '')
          // Remove commented imports
          .replaceAll(RegExp(r'//[^\n]*import[^\n]*\n'), '')
          // Clean up any remaining package references
          .replaceAll(
            RegExp(r'package:[^/]+/[^\.]+\.dart'),
            'package:$packageName/$relativePath.dart',
          )
          // Remove any duplicate package references
          .replaceAll(
            RegExp(r'package:([^/]+)/([^\.]+)\.dart'),
            'package:$packageName/$relativePath.dart',
          )
          // Clean up extra newlines
          .trim();

  // Add the required imports at the start
  processedCode = '${requiredImports.join('\n')}\n\n$processedCode';

  // Replace any remaining placeholders
  final replacements = {
    'your_project_name': packageName,
    'test_project': packageName,
    'your_file_name': relativePath,
  };

  for (final entry in replacements.entries) {
    processedCode = processedCode.replaceAll(entry.key, entry.value);
  }

  // Ensure proper spacing
  processedCode =
      processedCode.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim() + '\n';

  return processedCode;
}

/// Update pubspec.yaml with test dependencies
Future<void> updatePubspecWithTestDependencies() async {
  final pubspecFile = File('pubspec.yaml');
  String pubspecContent = pubspecFile.readAsStringSync();

  // Check if test dependency already exists
  if (!pubspecContent.contains('test:')) {
    // Find the dev_dependencies section or create it
    if (pubspecContent.contains('dev_dependencies:')) {
      // Add test dependency under existing dev_dependencies
      pubspecContent = pubspecContent.replaceFirst(
        RegExp(r'dev_dependencies:(\s+[^\s]+:[^\n]*\n)*'),
        'dev_dependencies:\n  test: ^1.21.0\n  ',
      );
    } else {
      // Add new dev_dependencies section
      pubspecContent += '\ndev_dependencies:\n  test: ^1.21.0\n';
    }

    // Write updated pubspec.yaml
    await pubspecFile.writeAsString(pubspecContent);
    print('Added test dependency to pubspec.yaml');
  } else {
    print('Test dependency already exists in pubspec.yaml');
  }
}
