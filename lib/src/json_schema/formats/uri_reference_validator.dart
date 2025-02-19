import 'package:json_schema2/src/json_schema/global_platform_functions.dart';
import 'package:json_schema2/src/json_schema/models/schema_version.dart';
import 'package:json_schema2/src/json_schema/models/validation_context.dart';

ValidationContext defaultUriReferenceValidator(
    ValidationContext context, String instanceData) {
  if (context.schemaVersion < SchemaVersion.draft6) return context;
  final isValid = defaultValidators.uriReferenceValidator;

  if (!isValid(instanceData)) {
    context.addError('"uri-reference" format not accepted $instanceData');
  }
  return context;
}
