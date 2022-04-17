import 'package:json_schema2/json_schema2.dart';
import 'package:test/test.dart';

void main() {
  test('valid', () {
    var valid = JsonSchema.createSchema(_kSchema).validate({
      'firstName': 'John',
      'lastName': 'Smith',
    });

    expect(valid, true);
  });
}

const _kSchema = r'''
$schema: http://json-schema.org/draft-06/schema#
type: object
title: Text
additionalProperties: false
required:
  - firstName
  - lastName
properties:
  firstName:
    type: string
  lastName:
    type: string
  middleName:
    type: string
''';
