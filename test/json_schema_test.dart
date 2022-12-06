import 'package:json_schema2/json_schema2.dart';
import 'package:test/test.dart';

void main() {
  test('fromRemoteUrl', () async {
    final schema = await JsonSchema.createSchemaFromUrl(
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/align.json',
    );

    final data = {
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

    final error = schema.validate(data);

    expect(error, false);
  });
}
