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
  int currentMedia = 1;

  @override
  void initState() {
    super.initState();
    mediaList = widget.items.take(widget.buffer).toList();
  }

  void loadMore() {
    if (currentMedia + 1 > mediaList.length && currentMedia < widget.items.length - 1) {
      final nextItem = widget.items[currentMedia + 1];
      mediaList.add(nextItem);
    }
  }

  void handleSwipe(bool isRight, dynamic mediaItem) {
    setState(() {
      currentMedia++;
      loadMore();
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
      children: mediaList.asMap().entries.map((entry) {
        int index = entry.key;
        var mediaItem = entry.value;

        return Positioned.fill(
          child: Draggable(
            childWhenDragging: const SizedBox.shrink(),
            feedback: Material(
              color: Colors.transparent,
              child: widget.content(mediaItem),
            ),
            child: widget.content(mediaItem),
            onDragEnd: (details) {
              bool isRight = details.offset.dx > 0;
              handleSwipe(isRight, mediaItem);
            },
          ),
        );
      }).toList().reversed.toList(), // Top card swipes first
    );
  }
}
