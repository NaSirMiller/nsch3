import "package:flutter/material.dart";

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final categories = [
      "All",
      "Food & Beverage",
      "Technology",
      "Health & Wellness",
      "Retail",
      "Energy",
    ];

    const primaryBlue = Color(0xFF4A90D9);
    const navyMid = Color(0xFF1A2E4A);
    const navyDark = Color(0xFF0A1628);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = category == "All"
              ? selectedCategory == null
              : selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (category == "All") {
                  onCategorySelected(null);
                } else {
                  onCategorySelected(selected ? category : null);
                }
              },
              backgroundColor: navyMid,
              selectedColor: primaryBlue.withOpacity(0.25),
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryBlue : primaryBlue.withOpacity(0.7),
              ),
              side: BorderSide(
                color: isSelected ? primaryBlue.withOpacity(0.6) : navyDark,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }
}
