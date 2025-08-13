import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final Widget child;
  final Function() onSwipeLeft;
  final Function() onSwipeRight;
  final double swipeThreshold;
  final double sensitivityFactor;

  const SwipeCard({
    super.key,
    required this.child,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    this.swipeThreshold = 310,
    this.sensitivityFactor = 2,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragOffset = 0;
  bool _isSwiped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_controller);
  }

  Future<void> _handleDragEnd() async {
    if (_dragOffset > widget.swipeThreshold) {
      _swipeOut(const Offset(2, 0)).then((_) {
        widget.onSwipeRight();
      });
    } else if (_dragOffset < -widget.swipeThreshold) {
      _swipeOut(const Offset(-2, 0)).then((_) {
        widget.onSwipeLeft();
      });
    } else {
      _resetPosition();
    }
  }

  Future<void> _swipeOut(Offset endOffset) async {
    setState(() => _isSwiped = true);
    _animation = Tween<Offset>(
            begin: Offset(_dragOffset / MediaQuery.of(context).size.width, 0),
            end: endOffset)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    await _controller.forward();
  }

  void _resetPosition() {
    _animation = Tween<Offset>(
      begin: Offset(_dragOffset / MediaQuery.of(context).size.width, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0).then((_) => setState(() => _dragOffset = 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSwiped) return const SizedBox.shrink();

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx * widget.sensitivityFactor;
        });
      },
      onHorizontalDragEnd: (_) => _handleDragEnd(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final offsetX = _controller.isAnimating
              ? _animation.value.dx * MediaQuery.of(context).size.width
              : _dragOffset;
          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.rotate(
              angle: offsetX / 1000,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
