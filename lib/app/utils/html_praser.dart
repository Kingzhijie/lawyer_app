import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

enum RichNodeType { text, link, image }

class RichNode {
  final RichNodeType type;

  /// text / link 显示内容
  final String? text;

  /// link / image url
  final String? url;

  RichNode({required this.type, this.text, this.url});

  @override
  String toString() {
    return 'RichNode(type: $type, text: $text, url: $url)';
  }
}

class RichTextParser {
  static List<RichNode> parse(String html) {
    final document = html_parser.parse(html);
    final List<RichNode> nodes = [];

    void walk(Node node) {
      if (node is Text) {
        final text = _cleanText(node.text);
        if (text.isNotEmpty) {
          nodes.add(RichNode(type: RichNodeType.text, text: text));
        }
        return;
      }

      if (node is Element) {
        switch (node.localName) {
          case 'a':
            final href = node.attributes['href'];
            final text = _cleanText(node.text);
            if (href != null && text.isNotEmpty) {
              nodes.add(
                RichNode(type: RichNodeType.link, text: text, url: href),
              );
            }
            return;

          case 'img':
            final src = node.attributes['src'];
            if (src != null && src.isNotEmpty) {
              nodes.add(RichNode(type: RichNodeType.image, url: src));
            }
            return;

          case 'br':
            nodes.add(RichNode(type: RichNodeType.text, text: '\n'));
            return;
        }

        for (final child in node.nodes) {
          walk(child);
        }
      }
    }

    for (final element in document.body?.nodes ?? []) {
      walk(element);
      // 段落后加换行
      nodes.add(RichNode(type: RichNodeType.text, text: '\n'));
    }

    return _mergeTextNodes(nodes);
  }

  /// 清理 HTML 文本
  static String _cleanText(String text) {
    return text
        .replaceAll('\u00A0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// 合并连续文本节点，避免 Text Widget 太多
  static List<RichNode> _mergeTextNodes(List<RichNode> list) {
    final List<RichNode> result = [];
    RichNode? buffer;

    for (final node in list) {
      if (node.type == RichNodeType.text) {
        if (buffer == null) {
          buffer = node;
        } else {
          buffer = RichNode(
            type: RichNodeType.text,
            text: '${buffer.text}${node.text}',
          );
        }
      } else {
        if (buffer != null) {
          result.add(buffer);
          buffer = null;
        }
        result.add(node);
      }
    }

    if (buffer != null) {
      result.add(buffer);
    }

    return result;
  }
}
