import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:react_messenger/controller/search_controller.dart';
import 'package:react_messenger/const/colors.dart';
import 'package:react_messenger/view/screens/search/widgets/search_appbar_title.dart';
import 'package:react_messenger/view/screens/search/widgets/search_gridview.dart';
import 'package:react_messenger/view/screens/search/widgets/search_user_list.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightDarColor,
          title: SearchAppBarTitle(
            searchController: searchController,
          ),
        ),
        body: Obx(
          () {
            if (searchController.postDocumentList.value != null) {
              if (searchController.postDocumentList.value!.size == 0) {
                return const Center(
                  child: Text('User not found'),
                );
              }
              return SearchUserList(searchController: searchController);
            } else {
              return const SearchGridview();
            }
          },
        ),
      ),
    );
  }
}
