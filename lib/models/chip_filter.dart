import 'package:flutter/material.dart';

String selectedFilter = '';

class Filter {
  ///
  /// Displayed label
  ///
  final String label;

  ///
  /// The displayed icon when selected
  ///
  final IconData icon;

  const Filter({required this.label, required this.icon});
}

// =============================================================================

///
/// The filter widget
///
class ChipsFilter extends StatefulWidget {
  ///
  /// The list of the filters
  ///
  final List<Filter> filters;

  final Function() onTap;

  ///
  /// The default selected index starting with 0
  ///
  final int selected;

  const ChipsFilter(
      {super.key,
      required this.filters,
      required this.onTap,
      this.selected = 0});

  @override
  State<ChipsFilter> createState() => _ChipsFilterState();
}

class _ChipsFilterState extends State<ChipsFilter> {
  ///
  /// Currently selected index
  ///
  late int selectedIndex;

  @override
  void initState() {
    // When [widget.selected] is defined, check the value and set it as
    // [selectedIndex]
    if (widget.selected >= 0 && widget.selected < widget.filters.length) {
      selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // clipBehavior: Clip.antiAlias,
      // make it not scrollable and new line when overflow
      shrinkWrap: true,
      itemBuilder: chipBuilder,
      itemCount: widget.filters.length,
      scrollDirection: Axis.horizontal,
    );
  }

  // String getSelectedFilter() {
  //   return widget.filters[selectedIndex].label;
  // }

  ///
  /// Build a single chip
  ///
  Widget chipBuilder(context, currentIndex) {
    Filter filter = widget.filters[currentIndex];
    bool isActive = selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = currentIndex;
          selectedFilter = widget.filters[currentIndex].label;
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        duration: const Duration(milliseconds: 500),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if (isActive)
            AnimatedContainer(
              margin: const EdgeInsets.only(right: 10),
              duration: const Duration(milliseconds: 500),
              child: isActive ? Icon(filter.icon) : const SizedBox(),
            ),
            Text(
              filter.label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getSelectedFilter() {
  return selectedFilter;
}
