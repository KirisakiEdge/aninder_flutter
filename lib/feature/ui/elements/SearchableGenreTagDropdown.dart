import 'package:flutter/material.dart';

class SearchableGenreTagDropdown extends StatefulWidget {
  final List<String> genres;
  final List<String> tags;
  final String labelText;
  final IconData trailingIcon;
  final Function(List<String>, List<String>) onSelectedListChanged;
  final Function(String, List<String>, List<String>) onDoneClick;

  const SearchableGenreTagDropdown({
    super.key,
    required this.genres,
    required this.tags,
    required this.labelText,
    required this.trailingIcon,
    required this.onSelectedListChanged,
    required this.onDoneClick,
  });

  @override
  State<SearchableGenreTagDropdown> createState() =>
      _SearchableGenreTagDropdownState();
}

class _SearchableGenreTagDropdownState
    extends State<SearchableGenreTagDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedGenres = [];
  List<String> selectedTags = [];

  void _openDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final searchText = _searchController.text;
            final filteredGenres = widget.genres
                .where((g) => g.toLowerCase().contains(searchText.toLowerCase()))
                .toList();
            final filteredTags = widget.tags
                .where((t) => t.toLowerCase().contains(searchText.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(widget.trailingIcon, color: Colors.white),
                        onPressed: () {
                          widget.onDoneClick(
                            _searchController.text,
                            selectedGenres,
                            selectedTags,
                          );
                          Navigator.pop(context);
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => setModalState(() {}),
                  )
                  ,
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        if (filteredGenres.isNotEmpty) ...[
                          const Text("Genres",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          ...filteredGenres.map((genre) => ListTile(
                            title: Text(genre,
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              if (!selectedGenres.contains(genre)) {
                                setState(() => selectedGenres.add(genre));
                                widget.onSelectedListChanged(
                                    selectedGenres, selectedTags);
                              }
                              _searchController.clear();
                              Navigator.pop(context);
                            },
                          )),
                          const Divider(color: Colors.grey),
                        ],
                        if (filteredTags.isNotEmpty) ...[
                          const Text("Tags",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          ...filteredTags.map((tag) => ListTile(
                            title: Text(tag,
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              if (!selectedTags.contains(tag)) {
                                setState(() => selectedTags.add(tag));
                                widget.onSelectedListChanged(
                                    selectedGenres, selectedTags);
                              }
                              _searchController.clear();
                              Navigator.pop(context);
                            },
                          )),
                        ],
                        if (filteredGenres.isEmpty && filteredTags.isEmpty)
                          ListTile(
                            title: const Text("No matches found",
                                style: TextStyle(color: Colors.grey)),
                            onTap: () => Navigator.pop(context),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChip(String text, VoidCallback onRemove) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey.withOpacity(0.3),
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 16),
      onDeleted: onRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openDropdown,
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(widget.trailingIcon, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (selectedGenres.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text("Selected Genres:",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedGenres
                .map((g) => _buildChip(g, () {
              setState(() => selectedGenres.remove(g));
            }))
                .toList(),
          ),
        ],
        if (selectedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text("Selected Tags:",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedTags
                .map((t) => _buildChip(t, () {
              setState(() => selectedTags.remove(t));
            }))
                .toList(),
          ),
        ],
      ],
    );
  }
}
