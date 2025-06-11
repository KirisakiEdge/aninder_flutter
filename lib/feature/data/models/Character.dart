import 'CharImage.dart';
import 'CharName.dart';

class Character {
  final int id;
  final CharName name;
  final CharImage image;
  final bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.isFavorite
  });
}
