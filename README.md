<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [JSON Schema](#json-schema)
  - [How To Create and Validate Against a Schema](#how-to-create-and-validate-against-a-schema)
    - [Synchronous Creation - Self Contained](#synchronous-creation---self-contained)
      - [Example](#example)
    - [Synchronous Creation, Local Ref Cache](#synchronous-creation-local-ref-cache)
      - [Example](#example-1)
    - [Asynchronous Creation, Remote HTTP Refs](#asynchronous-creation-remote-http-refs)
      - [Example](#example-2)
    - [Asynchronous Creation, From URL or File](#asynchronous-creation-from-url-or-file)
      - [Example 1 - URL](#example-1---url)
    - [Asynchronous Creation, with custom remote $refs:](#asynchronous-creation-with-custom-remote-refs)
      - [Example](#example-3)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# JSON Schema

**NOTE**: This project is archived and discontinued.  The original library this was forked from [json_schema](https://pub.dev/packages/json_schema) is being maintained again and now supports null safety.

  A *platform agnostic* (dart:html or dart:io) Dart library for validating JSON instances against JSON Schemas (multi-version support with latest of Draft 6).

![Build Status](https://travis-ci.org/workiva/json_schema.svg)

## How To Create and Validate Against a Schema
  
### Synchronous Creation - Self Contained
  
The simplest way to create a schema is to pass JSON data directly to `JsonSchema.createSchema` with a JSON `String`, or decoded JSON via Dart `Map` or `bool`. 

After creating any schema, JSON instances can be validated by calling `.validate(instance)` on that schema. By default, instances are expected to be pre-parsed JSON as native dart primitives (`Map`, `List`, `String`, `bool`, `num`, `int`). You can also optionally parse at validation time by passing in a string and setting `parseJson`: `schema.validate('{ "name": "any JSON object"}', parseJson: true)`.
    
  > Note: Creating JsonSchemas synchronously implies access to all $refs within the root schema. If you don't have access to all this data at the time of the construction, see "Asynchronous Creation" examples below.


#### Example

A schema can be created with a Map that is either hand-crafted, referenced from a JSON file, or *previously* fetched from the network or file system.

```dart
import 'package:json_schema2/json_schema2.dart';

main() {
  /// Define schema in a Dart [Map] or use a JSON [String].
  final mustBeIntegerSchemaMap = {"type": "integer"};

  // Create some examples to validate against the schema.
  final n = 3;
  final decimals = 3.14;
  final str = 'hi';

  // Construct the schema from the schema map or JSON string.
  final schema = JsonSchema.createSchema(mustBeIntegerSchemaMap);

  print('$n => ${schema.validate(n)}'); // true
  print('$decimals => ${schema.validate(decimals)}'); // false
  print('$str => ${schema.validate(str)}'); // false
}
```

### Synchronous Creation, Local Ref Cache

If you want to create `JsonSchema`s synchronously, and you have $refs that cannot be resolved within the root schema, but you have a cache of those $ref'd schemas locally, you can write a `RefProvider` to get them during schema evaluation.

#### Example

```dart 
import 'dart:convert';
import 'package:json_schema2/json_schema2.dart';

main() {
  final referencedSchema = {
    r"$id": "https://example.com/geographical-location.schema.json",
    r"$schema": "http://json-schema.org/draft-06/schema#",
    "title": "Longitude and Latitude",
    "description": "A geographical coordinate on a planet (most commonly Earth).",
    "required": ["latitude", "longitude"],
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "latitude": {"type": "number", "minimum": -90, "maximum": 90},
      "longitude": {"type": "number", "minimum": -180, "maximum": 180}
    }
  };

  final RefProvider refProvider = (String ref) {
    final Map references = {
      'https://example.com/geographical-location.schema.json': JsonSchema.createSchema(referencedSchema),
    };

    if (references.containsKey(ref)) {
      return references[ref];
    }

    return null;
  };

  final schema = JsonSchema.createSchema({
    'type': 'array',
    'items': {r'$ref': 'https://example.com/geographical-location.schema.json'}
  }, refProvider: refProvider);

  final workivaLocations = [
    {
      'name': 'Ames',
      'latitude': 41.9956731,
      'longitude': -93.6403663,
    },
    {
      'name': 'Scottsdale',
      'latitude': 33.4634707,
      'longitude': -111.9266617,
    }
  ];

  final badLocations = [
    {
      'name': 'Bad Badlands',
      'latitude': 181,
      'longitude': 92,
    },
    {
      'name': 'Nowhereville',
      'latitude': -2000,
      'longitude': 7836,
    }
  ];

  print('${json.encode(workivaLocations)} => ${schema.validate(workivaLocations)}');
  print('${json.encode(badLocations)} => ${schema.validate(badLocations)}');
}
```

### Asynchronous Creation, Remote HTTP Refs

If you have schemas that have nested $refs that are HTTP URIs that are publicly accessible, you can use `Future<JsonSchema> JsonSchema.createSchemaAsync` and the references will be fetched as needed during evaluation. You can also use `JsonSchema.createSchemaFromUrl` if you want to fetch the root schema remotely as well (see next example).

#### Example

```dart
import 'dart:io';

import 'package:json_schema2/json_schema2.dart';

main() async {

  // Schema Defined as a JSON String
  final schema = await JsonSchema.createSchemaAsync(r'''
  {
    "type": "array",
    "items": {
      "$ref": "https://raw.githubusercontent.com/json-schema-org/JSON-Schema-Test-Suite/master/remotes/integer.json"
    }
  }
  ''');

  // Create some examples to validate against the schema.
  final numbersArray = [1, 2, 3];
  final decimalsArray = [3.14, 1.2, 5.8];
  final strArray = ['hello', 'world'];

  print('$numbersArray => ${schema.validate(numbersArray)}'); // true
  print('$decimalsArray => ${schema.validate(decimalsArray)}'); // false
  print('$strArray => ${schema.validate(strArray)}'); // false

  // Exit the process cleanly (VM Only).
  exit(0);
}
```

### Asynchronous Creation, From URL or File

You can also create a schema directly from a publicly accessible URL, like so:

#### Example 1 - URL

```dart
import 'dart:io';

import 'package:json_schema2/json_schema2.dart';

main() async {
  final url = "https://raw.githubusercontent.com/json-schema-org/JSON-Schema-Test-Suite/master/remotes/integer.json";

  final schema = await JsonSchema.createSchemaFromUrl(url);

  // Create some examples to validate against the schema.
  final n = 3;
  final decimals = 3.14;
  final str = 'hi';

  print('$n => ${schema.validate(n)}'); // true
  print('$decimals => ${schema.validate(decimals)}'); // false
  print('$str => ${schema.validate(str)}'); // false

  // Exit the process cleanly (VM Only).
  exit(0);
}
```

### Asynchronous Creation, with custom remote $refs:

If you have nested $refs that are either non-HTTP URIs or non-publicly-accessible HTTP $refs, you can supply an `RefProviderAsync` to `createSchemaAsync`, and perform any custom logic you need.

#### Example

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:json_schema2/json_schema2.dart';

main() async {
  final referencedSchema = {
    r"$id": "https://example.com/geographical-location.schema.json",
    r"$schema": "http://json-schema.org/draft-06/schema#",
    "title": "Longitude and Latitude",
    "description": "A geographical coordinate on a planet (most commonly Earth).",
    "required": ["latitude", "longitude"],
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "latitude": {"type": "number", "minimum": -90, "maximum": 90},
      "longitude": {"type": "number", "minimum": -180, "maximum": 180}
    }
  };

  final RefProviderAsync refProvider = (String ref) async {
    final Map references = {
      'https://example.com/geographical-location.schema.json': JsonSchema.createSchema(referencedSchema),
    };

    if (references.containsKey(ref)) {
      // Silly example that adds a 1 second delay.
      // In practice, you could make any service call here,
      // parse the results into a schema, and return.
      await new Future.delayed(new Duration(seconds: 1));
      return references[ref];
    }

    // Fall back to default URL $ref behavior
    return await JsonSchema.createSchemaFromUrl(ref);
  };

  final schema = await JsonSchema.createSchemaAsync({
    'type': 'array',
    'items': {r'$ref': 'https://example.com/geographical-location.schema.json'}
  }, refProvider: refProvider);

  final workivaLocations = [
    {
      'name': 'Ames',
      'latitude': 41.9956731,
      'longitude': -93.6403663,
    },
    {
      'name': 'Scottsdale',
      'latitude': 33.4634707,
      'longitude': -111.9266617,
    }
  ];

  final badLocations = [
    {
      'name': 'Bad Badlands',
      'latitude': 181,
      'longitude': 92,
    },
    {
      'name': 'Nowhereville',
      'latitude': -2000,
      'longitude': 7836,
    }
  ];

  print('${json.encode(workivaLocations)} => ${schema.validate(workivaLocations)}');
  print('${json.encode(badLocations)} => ${schema.validate(badLocations)}');

  exit(0);
}
```
