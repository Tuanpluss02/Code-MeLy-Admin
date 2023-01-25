// import 'package:flutter/material.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// class SearchBar extends StatefulWidget {
//   const SearchBar({super.key});

//   @override
//   State<SearchBar> createState() => _SearchBarState();
// }

// class _SearchBarState extends State<SearchBar> {
//   late FloatingSearchBarController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = FloatingSearchBarController();
//     // filteredSearchHistory = filterSearchTerms(filter: null);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FloatingSearchBar(
//         controller: controller,
//         body: SearchResultsListView(
//           searchTerm: selectedTerm,
//         ),
//         builder: (BuildContext context, Animation<double> transition) {},
//       ),
//     );
//   }
// }
