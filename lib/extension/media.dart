import 'package:html/parser.dart' as html_parser;

extension HtmlTextCleaner on String? {
  String get filteredDesc {
    if (this == null) return "";
    final document = html_parser.parse(this);
    return document.body?.text.trim() ?? "";
  }
}