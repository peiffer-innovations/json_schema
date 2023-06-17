// GENERATED CODE - DO NOT MODIFY BY HAND
Map<String, String> additionalRemotes = {
  "http://localhost:4321/bar.json": r"""{ 
  "baz": { "$ref": "http://localhost:4321/string.json#" }
} """,
  "http://localhost:4321/date-keyword-meta-schema.json": r"""{
  "$schema": "http://localhost:4321/date-keyword-meta-schema.json",
  "$id": "http://localhost:4321/date-keyword-meta-schema.json",
  "$vocabulary": {
    "https://json-schema.org/draft/2020-12/vocab/core": true,
    "https://json-schema.org/draft/2020-12/vocab/applicator": true,
    "https://json-schema.org/draft/2020-12/vocab/unevaluated": true,
    "https://json-schema.org/draft/2020-12/vocab/validation": true,
    "https://json-schema.org/draft/2020-12/vocab/meta-data": true,
    "https://json-schema.org/draft/2020-12/vocab/format-annotation": true,
    "https://json-schema.org/draft/2020-12/vocab/content": true,
    "http://localhost:4321/vocab/min-date": true
  },
  "allOf": [
    {"$ref": "https://json-schema.org/draft/2020-12/schema" }
  ],
  "properties":{
    "minDate": {
      "type": "string",
      "format": "date"
    }
  }
}
""",
  "http://localhost:4321/string.json": r"""{
    "type": "string"
}""",
  "http://localhost:4321/string_ref.json": r"""{ "$ref": "http://localhost:4321/string.json" }"""
};
