import 'package:aninder/feature/ui/elements/SwipeCard.dart';
import 'package:flutter/material.dart';

class PaginatedSwappedCards extends StatefulWidget {
  final List<dynamic> items;
  final int buffer;
  final Function(dynamic) onSwipeRight;
  final Function(dynamic) onSwipeLeft;
  final Widget Function(dynamic) content;

  const PaginatedSwappedCards({
    super.key,
    required this.items,
    this.buffer = 3,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.content,
  });

  @override
  State<PaginatedSwappedCards> createState() => _PaginatedSwappedCardsState();
}

class _PaginatedSwappedCardsState extends State<PaginatedSwappedCards> {
  late List<dynamic> mediaList;
  int nextItemIndex = 0;

  @override
  void initState() {
    super.initState();
    mediaList = [];

    for (int i = 0; i < widget.buffer && i < widget.items.length; i++) {
      mediaList.add(widget.items[i]);
      nextItemIndex++;
    }
  }

  void handleSwipe(bool isRight, dynamic mediaItem) {
    setState(() {
      mediaList.remove(mediaItem);

      if (nextItemIndex < widget.items.length) {
        mediaList.add(widget.items[nextItemIndex]);
        nextItemIndex++;
      }
    });

    if (isRight) {
      widget.onSwipeRight(mediaItem);
    } else {
      widget.onSwipeLeft(mediaItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: mediaList
          .asMap()
          .entries
          .map((entry) {
        final mediaItem = entry.value;

        return SwipeCard(
          key: ValueKey(mediaItem),
          onSwipeLeft: () => handleSwipe(false, mediaItem),
          onSwipeRight: () => handleSwipe(true, mediaItem),
          child: widget.content(mediaItem),
        );
      })
          .toList()
          .reversed
          .toList(),
    );
  }
}
