import 'package:json_schema2/src/json_schema/formats/validation_regexes.dart';
import 'package:json_schema2/src/json_schema/models/schema_version.dart';
import 'package:json_schema2/src/json_schema/models/validation_context.dart';

ValidationContext defaultUuidValidator(
    ValidationContext context, String instanceData) {
  if (context.schemaVersion < SchemaVersion.draft2019_09) return context;
  if (JsonSchemaValidationRegexes.uuid.firstMatch(instanceData) == null) {
    context.addError('"uuid" format not accepted $instanceData');
  }
  return context;
}
