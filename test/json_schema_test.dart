import 'package:json_schema2/json_schema2.dart';
import 'package:test/test.dart';

void main() {
  test('fromRemoteUrl', () async {
    var schema = await JsonSchema.createSchemaFromUrl(
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/align.json',
    );

    var data = {
      'type': 'align',
      'args': {'alignment': 'topCenter'},
      'child': {
        'type': 'container',
        'args': {'color': '#E1BEE7', 'padding': 16},
        'child': {
          'type': 'text',
          'args': {'text': 'topCenter'}
        }
      }
    };

    var error = schema.validate(data);

    expect(error, false);
  });
}
