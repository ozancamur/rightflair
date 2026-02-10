class TextParser {
  /// Parse mentions from text (e.g., @username)
  static List<String> parseMentions(String text) {
    final mentionRegex = RegExp(r'@([a-zA-Z0-9_]+)');
    final matches = mentionRegex.allMatches(text);
    return matches.map((match) => match.group(1)!).toSet().toList();
  }

  /// Parse tags from text (e.g., #tag)
  static List<String> parseTags(String text) {
    final tagRegex = RegExp(r'#([a-zA-Z0-9_]+)');
    final matches = tagRegex.allMatches(text);
    return matches.map((match) => match.group(1)!).toSet().toList();
  }

  /// Remove mentions and tags from text, keeping only plain text
  static String cleanText(String text) {
    // Remove mentions (@username)
    String cleaned = text.replaceAll(RegExp(r'@[a-zA-Z0-9_]+'), '');
    // Remove tags (#tag)
    cleaned = cleaned.replaceAll(RegExp(r'#[a-zA-Z0-9_]+'), '');
    // Remove extra spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }
}
