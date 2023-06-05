import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:product_list/src/horizontal_filter_chip_list.dart';
import 'package:product_list/src/paged_product_list_view.dart';
import 'package:product_list/src/product_list_bloc.dart';
import 'package:product_repository/product_repository.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductListBloc(productRepository: ProductRepository()),
      child: ProductListView(),
    );
  }
}

@visibleForTesting
class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final _pagingController = PagingController<int, Product>(
    firstPageKey: firstPageNumber,
  );

  final _searchBarController = TextEditingController();

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((page) {
      final isSubsequencePage = page > firstPageNumber;
      if (isSubsequencePage) _bloc.add(ProductListNextPageRequested(page));
    });

    _searchBarController.addListener(() {
      _bloc.add(ProductListSearchTermChanged(_searchBarController.text));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<ProductListBloc, ProductListState>(
              listener: (context, state) {
                final searchBarText = _searchBarController.text;
                final isSearch = state.filter != null &&
                    state.filter is ProductListFilterBySearchTerm;

                if (searchBarText.isNotEmpty && !isSearch) {
                  _searchBarController.text = '';
                }

                _pagingController.value = state.toPagingState();
              },
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  SearchBar(
                    controller: _searchBarController,
                  ),
                  const SizedBox(height: 24),
                  const HorizontalFilterChipList(),
                  const SizedBox(height: 24),
                  Expanded(
                      child: PagedProductListView(
                    pagingController: _pagingController,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on ProductListState {
  PagingState<int, Product> toPagingState() => PagingState(
        error: error,
        itemList: itemList,
        nextPageKey: nextPage,
      );
}
