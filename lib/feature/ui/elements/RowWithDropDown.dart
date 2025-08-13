import 'package:flutter/material.dart';

class RowWithDropdown extends StatefulWidget {
  final List<String> items;
  final void Function(String) onSelected;
  final String? initialValue;

  const RowWithDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.initialValue,
  });

  @override
  State<RowWithDropdown> createState() => _RowWithDropdownState();
}

class _RowWithDropdownState extends State<RowWithDropdown> {
  late String selectedText;

  @override
  void initState() {
    super.initState();
    selectedText = widget.initialValue ??
        widget.items.firstWhere(
          (e) => e == "COMPLETED",
          orElse: () =>
              widget.items.isNotEmpty ? widget.items.first : "COMPLETED",
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          selectedText = value;
        });
        widget.onSelected(value);
      },
      itemBuilder: (context) => widget.items
          .map((item) => PopupMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      child: Row(
        children: [
          Text(selectedText,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_back),
        ],
      ),
    );
  }
}
