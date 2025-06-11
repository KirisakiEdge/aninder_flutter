import 'package:aninder/feature/data/models/Title.dart';
import 'package:html/parser.dart' as html_parser;

import 'Character.dart';
import 'CoverImage.dart';
import 'RelationType.dart';

class Media {
  final int id;
  final String type;
  final Title title;
  final String bannerImage;
  final CoverImage? coverImage;
  final List<String> genres;
  final List<Tag> tags;
  final String? description;
  final Nodes characters;
  final Relations relations;
  final bool isFavourite;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.bannerImage,
    required this.coverImage,
    required this.genres,
    required this.tags,
    required this.description,
    required this.characters,
    required this.relations,
    required this.isFavourite,
  });

  String getFilteredDesc() {
    if (description == null) return '';
    return html_parser.parse(description!).body?.text ?? '';
  }
}

class Tag {
  final String name;

  Tag({required this.name});
}

class Nodes {
  final List<Character> nodes;

  Nodes({required this.nodes});
}

class Relations {
  final List<MediaEdge> edges;

  Relations({required this.edges});
}

class MediaEdge {
  final RelationType relationType;
  final Media node;

  MediaEdge({
    required this.relationType,
    required this.node,
  });
}