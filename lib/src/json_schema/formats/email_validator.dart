import 'package:json_schema/src/json_schema/global_platform_functions.dart';
import 'package:json_schema/src/json_schema/models/validation_context.dart';

ValidationContext defaultEmailValidator(ValidationContext context, String instanceData) {
  final isValid = defaultValidators.emailValidator;

  if (!isValid(instanceData)) {
    context.addError('"email" format not accepted $instanceData');
  }
  return context;
}
