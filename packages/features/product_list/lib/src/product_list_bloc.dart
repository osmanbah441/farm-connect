import 'package:equatable/equatable.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

const firstPageNumber = 1;

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({
    required this.productRepository,
  }) : super(const ProductListState()) {
    _registerEventHanders();

    add(const ProductListNextPageRequested(firstPageNumber));
  }

  final ProductRepository productRepository;

  void _registerEventHanders() => on<ProductListEvent>((event, emitter) async {
        switch (event) {
          case ProductListCategoryChanged():
            return await _handleProductListCategoryChanged(
              event.category,
              emitter,
            );

          case ProductListNextPageRequested():
            return await _handleProductListNextPageRequested(
              event.nextPage,
              emitter,
            );

          case ProductListSearchTermChanged():
            return await _handleProductListSearchTermChanged(
              event.searchTerm,
              emitter,
            );
        }
      });

  Stream<ProductListState> _fetchProductPage(
    int page, {
    required ProductListFetchPolicy fetchPolicy,
    bool isRefresh = false,
  }) async* {
    final currentlyAppliedFilter = state.filter;

    final pageStream = productRepository.fetchProductListPage(
      page,
      fetchPolicy: fetchPolicy,
      category: currentlyAppliedFilter is ProductListFilterByCategory
          ? currentlyAppliedFilter.category
          : null,
      searchTerm: currentlyAppliedFilter is ProductListFilterBySearchTerm
          ? currentlyAppliedFilter.searchTerm
          : '',
    );

    try {
      await for (final newPage in pageStream) {
        final newItems = newPage.productList;
        final oldItems = state.itemList ?? const [];
        final completedItem = isRefresh || page == firstPageNumber
            ? newItems
            : (newItems + oldItems);

        final nextPage = newPage.isLastPage ? null : page + 1;
        yield ProductListState.success(
          itemList: completedItem,
          nextPage: nextPage,
          filter: currentlyAppliedFilter,
          isRefresh: isRefresh,
        );
      }
    } catch (e) {
      // TODO: handler error
    }
  }

  Future<void> _handleProductListNextPageRequested(
      int nextPage, Emitter<ProductListState> emitter) async {
    emitter(state.copyWithNewError(null));

    final pageStream = _fetchProductPage(
      nextPage,
      fetchPolicy: ProductListFetchPolicy.networkOnly,
    );

    return emitter.onEach(pageStream, onData: emitter);
  }

  Future<void> _handleProductListCategoryChanged(
    ProductCategory? category,
    Emitter<ProductListState> emitter,
  ) async {
    emitter(ProductListState.loadingNewCategory(category: category));

    final pageStream = _fetchProductPage(
      firstPageNumber,
      fetchPolicy: ProductListFetchPolicy.cachePreferably,
    );

    return emitter.onEach(pageStream, onData: emitter);
  }

  Future<void> _handleProductListSearchTermChanged(
    String searchTerm,
    Emitter<ProductListState> emitter,
  ) async {
    emitter(ProductListState.loadingSearchTerm(searchTerm));

    final pageStream = _fetchProductPage(
      firstPageNumber,
      fetchPolicy: ProductListFetchPolicy.cacheAndNetwork,
    );

    return emitter.onEach(pageStream, onData: emitter);
  }
}
