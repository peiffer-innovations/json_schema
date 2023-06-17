import 'package:json_schema2/src/json_schema/models/validation_context.dart';

ValidationContext defaultDateTimeValidator(
    ValidationContext context, String instanceData) {
  try {
    DateTime.parse(instanceData);
  } catch (e) {
    context.addError('"date-time" format not accepted $instanceData');
  }
  return context;
}
