import 'package:aninder/extension/media.dart';
import 'package:aninder/graphql/get_media_list.graphql.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeCard extends StatefulWidget {
  final Query$GetMediaListByYear$Page$media anime;
  final Function(int) animeFavouriteIconClick;
  final Function(int) charFavouriteIconClick;
  final Function(int) goToAnimePageClick;

  const AnimeCard({
    super.key,
    required this.anime,
    required this.animeFavouriteIconClick,
    required this.charFavouriteIconClick,
    required this.goToAnimePageClick,
  });

  @override
  State<AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<AnimeCard> {
  late bool isAnimeFavorite;

  @override
  void initState() {
    super.initState();
    isAnimeFavorite = widget.anime.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.anime.coverImage?.extraLarge ?? '',
                    placeholder: (context, url) => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.anime.title!.userPreferred!,
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                          widget.anime.title?.romaji ??
                              widget.anime.title?.english ??
                              '',
                          style: Theme.of(context).textTheme.titleMedium),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          widget.anime.description!.filteredDesc,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.anime.characters!.nodes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount:
                          widget.anime.characters!.nodes!.take(12).length,
                      itemBuilder: (context, index) {
                        final char = widget.anime.characters!.nodes![index]!;
                        return CharacterCard(
                          char: char,
                          onFavouriteClick: widget.charFavouriteIconClick,
                        );
                      },
                    ),
                  ),
                GestureDetector(
                  onTap: () => widget.goToAnimePageClick(widget.anime.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: const Text(
                      'Click for more',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: Icon(
                isAnimeFavorite ? Icons.favorite : Icons.favorite_border,
                size: 36,
                color: isAnimeFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                widget.animeFavouriteIconClick(widget.anime.id);
                setState(() {
                  isAnimeFavorite = !isAnimeFavorite;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterCard extends StatefulWidget {
  final Query$GetMediaListByYear$Page$media$characters$nodes char;
  final Function(int) onFavouriteClick;

  const CharacterCard({
    super.key,
    required this.char,
    required this.onFavouriteClick,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  late bool isCharacterFavorite;

  @override
  void initState() {
    super.initState();
    isCharacterFavorite = widget.char.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: widget.char.image!.large!,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                isCharacterFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24,
                color: isCharacterFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                widget.onFavouriteClick(widget.char.id);
                setState(() {
                  isCharacterFavorite = !isCharacterFavorite;
                });
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Text(
                widget.char.name!.full!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
