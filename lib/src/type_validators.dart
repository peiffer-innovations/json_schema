import 'package:json_schema2/json_schema2.dart';

class TypeValidators {
  static List list(String key, dynamic value) {
    if (value is List) return value;
    throw FormatExceptions.list(key, value);
  }

  static List nonEmptyList(String key, dynamic value) {
    final theList = list(key, value);
    if (theList.isNotEmpty == true) {
      return theList;
    }
    throw FormatExceptions.error('$key must be a non-empty list: $value');
  }

  static List uniqueList(String key, dynamic value) {
    var i = 0;
    final enumValues = TypeValidators.nonEmptyList(key, value);
    enumValues.forEach((v) {
      for (var j = i + 1; j < value.length; j++) {
        if (JsonSchemaUtils.jsonEqual(value[i], value[j])) {
          throw FormatExceptions.error(
              'enum values must be unique: $value [$i]==[$j]');
        }
      }
      i++;
    });
    return enumValues;
  }

  /// Validate a dynamic value is a String.
  static String string(String key, dynamic value) {
    if (value is String) return value;
    throw FormatExceptions.string(key, value);
  }

  static String nonEmptyString(String key, dynamic value) {
    TypeValidators.string(key, value);
    if (value.isNotEmpty) return value;
    throw FormatExceptions.error('$key must be a non-empty string: $value');
  }

  static List<SchemaType?> typeList(String key, dynamic value) {
    List<SchemaType?> typeList;
    if (value is String) {
      typeList = [SchemaType.fromString(value)];
    } else if (value is List) {
      typeList = value.map((v) => SchemaType.fromString(v)).toList();
    } else {
      throw FormatExceptions.error(
          '$key must be string or array: ${value.runtimeType}');
    }
    if (!typeList.contains(null)) {
      return typeList;
    }
    throw FormatExceptions.error('$key(s) invalid $value');
  }

  static dynamic nonNegative(String key, dynamic value) {
    if (value < 0) {
      throw FormatExceptions.error('$key must be non-negative: $value');
    }
    return value;
  }

  static int nonNegativeInt(String key, dynamic value) {
    if (value is int) {
      return nonNegative(key, value);
    }
    throw FormatExceptions.int(key, value);
  }

  static num number(String key, dynamic value) {
    if (value is num) {
      return value;
    }
    throw FormatExceptions.num(key, value);
  }

  static num nonNegativeNum(String key, dynamic value) {
    number(key, value);
    if (value > 0) {
      return value;
    }
    throw FormatExceptions.nonNegativeNum(key, value);
  }

  static bool boolean(String key, dynamic value) {
    if (value is bool) {
      return value;
    }
    throw FormatExceptions.bool(key, value);
  }

  static Map object(String? key, dynamic value) {
    if (value is Map) {
      return value;
    }
    throw FormatExceptions.object(key, value);
  }

  static SchemaVersion jsonSchemaVersion4Or6(String key, dynamic value) {
    string(key, value);
    final schemaVersion = SchemaVersion.fromString(value);
    if (schemaVersion != null) {
      return schemaVersion;
    }
    throw FormatExceptions.error('Only draft 4 and draft 6 schemas supported');
  }

  static Uri uri(String key, dynamic value) {
    final id = string('id', value);
    try {
      return Uri.parse(id);
    } catch (e) {
      throw FormatExceptions.error('$key must be a valid URI: $value ($e)');
    }
  }
}
