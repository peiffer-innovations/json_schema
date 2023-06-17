class JsonSchemaValidationRegexes {
  // Spec: https://datatracker.ietf.org/doc/html/rfc3339#appendix-A
  static RegExp duration = RegExp(
      r'^P(\d{1,}W|T(\d{1,}H(\d{1,}M(\d{1,}S)?)?|\d{1,}M(\d{1,}S)?|\d{1,}S)|(\d{1,}D|\d{1,}M(\d{1,}D)?|\d{1,}Y(\d{1,}M(\d{1,}D)?)?)(T(\d{1,}H(\d{1,}M(\d{1,}S)?)?|\d{1,}M(\d{1,}S)?|\d{1,}S))?)$');

  // Spec: https://datatracker.ietf.org/doc/html/rfc4122
  static RegExp uuid =
      RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-5][0-9a-fA-F]{3}-[089abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');

  // From: https://emailregex.com/ (JavaScript)
  static RegExp email = RegExp(
      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static RegExp ipv4 = RegExp(r'^(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.'
      r'(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.'
      r'(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))\.'
      r'(\d|[1-9]\d|1\d\d|2([0-4]\d|5[0-5]))$');

  // Spec: https://datatracker.ietf.org/doc/html/rfc1034
  static RegExp hostname = RegExp(r'^(?=.{1,255}$)'
      r'[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?'
      r'(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?)*\.?$');

  // Spec: https://datatracker.ietf.org/doc/html/rfc1123
  static RegExp hostnameDraft2019 = RegExp(r'^(?=.{1,255}$)'
      r'[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?'
      r'(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?)*\.?$');

  // From: https://github.com/johno/domain-regex/blob/master/index.js
  // Spec: https://datatracker.ietf.org/doc/html/rfc1034
  static RegExp idnHostname = RegExp(r'\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b');

  // Spec: https://datatracker.ietf.org/doc/html/rfc1123
  static RegExp idnHostnameDraft2019 =
      RegExp(r'\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b');

  static RegExp jsonPointer = RegExp(r'^(?:\/(?:[^~/]|~0|~1)*)*$');

  // Spec: https://tools.ietf.org/html/draft-handrews-relative-json-pointer-01
  // From: https://github.com/ajv-validator/ajv-formats/blob/ec288c47a25024b36ea4117d7904f0308487d3de/src/formats.ts#L71
  static RegExp relativeJsonPointer = RegExp(r'^(?:\/(?:[^~/]|~0|~1)*)*$');

  // Spec: https://tools.ietf.org/html/rfc3339#section-5.6
  // From: https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch04s07.html
  static RegExp fullTime =
      RegExp(r'^(2[0-3]|[01][0-9]):?([0-5][0-9]):?([0-5][0-9])(Z|[+-](?:2[0-3]|[01][0-9])(?::?(?:[0-5][0-9]))?)$');

  // Spec: https://tools.ietf.org/html/rfc3339#section-5.6
  // From: https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch04s07.html
  static RegExp fullDate = RegExp(r'^([0-9]{4})(-?)(1[0-2]|0[1-9])\2(3[01]|0[1-9]|[12][0-9])$');

  // https://json-schema.org/draft/2019-09/json-schema-core.html#rfc.section.8.2.3
  static RegExp anchor = RegExp(r"^[A-Za-z][\w\-.:]+$");
}
