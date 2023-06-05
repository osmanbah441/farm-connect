import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PagedProductListView extends StatelessWidget {
  const PagedProductListView({
    super.key,
    required this.pagingController,
  });

  final PagingController<int, Product> pagingController;
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Product>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.category.name),
          );
        },
      ),
    );
  }
}
