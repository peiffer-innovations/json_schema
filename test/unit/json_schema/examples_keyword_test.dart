import 'package:json_schema/json_schema.dart';
import 'package:test/test.dart';

main() {
  group('examples keyword', () {
    group('in draft4', () {
      test('should NOT be supported', () {
        final schema = JsonSchema.create({
          "type": "string",
          "examples": ["This", "message", "is", "lost."]
        }, schemaVersion: SchemaVersion.draft4);

        expect(schema.examples.isEmpty, isTrue);
      });
      test('should still pass the default value to the examples getter', () {
        final schema = JsonSchema.create({
          "type": "string",
          "examples": ["This", "message", "is", "lost."],
          "default": "But this one isn't.",
        }, schemaVersion: SchemaVersion.draft4);

        expect(schema.examples.length, equals(1));
        expect(schema.examples.single, equals("But this one isn't."));
      });
    });

    group('in draft 6', () {
      test('should be supported', () {
        final schema = JsonSchema.create({
          "type": "string",
          "examples": ["This", "message", "is", "not", "lost!"]
        }, schemaVersion: SchemaVersion.draft6);

        expect(schema.examples.length, equals(5));
        expect(schema.examples[4], equals('lost!'));
      });
      test('should append the default value to the examples getter', () {
        final schema = JsonSchema.create({
          "type": "string",
          "examples": ["This", "message", "is", "not", "lost!"],
          "default": "And neither is this one",
        }, schemaVersion: SchemaVersion.draft6);

        expect(schema.examples.length, equals(6));
        expect(schema.examples[0], equals("This"));
        expect(schema.examples[5], equals("And neither is this one"));
      });
    });
  });
}
