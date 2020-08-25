/// default regex
const String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';

String sprintf(String template, List replacements) {
  var regExp = RegExp(placeholderPattern);
  assert(regExp.allMatches(template).length == replacements.length,
  "Template and Replacements length are incompatible");

  for (var replacement in replacements) {
    template = template.replaceFirst(regExp, replacement.toString());
  }

  return template;
}