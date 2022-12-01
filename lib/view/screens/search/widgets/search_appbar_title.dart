import 'package:flutter/material.dart';

import '../../../../controller/search_controller.dart';

class SearchAppBarTitle extends StatelessWidget {
  const SearchAppBarTitle({
    super.key,
    required this.searchController,
  });
  final SearchController searchController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            cursorColor: Colors.white,
            controller: searchController.searchController,
            decoration: const InputDecoration(
              labelText: "Search for a user",
              labelStyle: TextStyle(color: Colors.white),
            ),
            onFieldSubmitted: (String value) {
              if (value.isEmpty) {
                searchController.postDocumentList.value = null;
                return;
              }
              searchController.initSearchingPost(value);
            },
            onChanged: (String value) {
              if (value.isEmpty) {
                searchController.postDocumentList.value = null;
                return;
              }
              searchController.name = value;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            searchController.initSearchingPost(searchController.name);
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}
