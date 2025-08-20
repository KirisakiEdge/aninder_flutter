import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Routes.dart';
import '../../../main.dart';

class ScreenWithNavigationBar extends StatelessWidget {
  final Widget child;
  const ScreenWithNavigationBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(Routes.SEARCH.name)) return 1;
    if (location.startsWith(Routes.PROFILE.name)) return 2;
    return 0; // default HOME
  }

 /* bool _shouldShowBottomBar(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // Show bottom bar only on main routes
    return location.startsWith(Routes.HOME.name) ||
        location.startsWith(Routes.SEARCH.name) ||
        location.startsWith(Routes.PROFILE.name);
  }*/

  void _onItemTapped(BuildContext context, int index) {
    context.go(items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isShowBar = true; //_shouldShowBottomBar(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: isShowBar
          ? BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: items.map((item) {
          final index = items.indexOf(item);
          final isSelected = selectedIndex == index;
          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.selectedIcon : item.unselectedIcon),
            label: item.title,
          );
        }).toList(),
      )
          : null,
    );
  }
}