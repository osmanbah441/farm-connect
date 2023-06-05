part of 'product_list_bloc.dart';

final class ProductListState extends Equatable {
  const ProductListState({
    this.itemList,
    this.nextPage,
    this.filter,
    this.error,
    this.refreshError,
  });

  final List<Product>? itemList;
  final int? nextPage;
  final ProductListFilter? filter;
  final dynamic error;
  final dynamic refreshError;

  ProductListState.loadingSearchTerm(String searchTerm)
      : this(
          filter: searchTerm.isEmpty
              ? null
              : ProductListFilterBySearchTerm(searchTerm),
        );

  ProductListState.loadingNewCategory({
    required ProductCategory? category,
  }) : this(
          filter:
              category != null ? ProductListFilterByCategory(category) : null,
        );

  const ProductListState.success({
    required List<Product> itemList,
    required int? nextPage,
    required ProductListFilter? filter,
    required bool isRefresh,
  }) : this(
          itemList: itemList,
          nextPage: nextPage,
          filter: filter,
        );

  ProductListState copyWithNewError(dynamic error) => ProductListState(
        error: error,
        itemList: itemList,
        filter: filter,
        nextPage: nextPage,
        refreshError: refreshError,
      );

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        filter,
        error,
        refreshError,
      ];
}

abstract class ProductListFilter extends Equatable {
  const ProductListFilter();
}

class ProductListFilterByCategory extends ProductListFilter {
  const ProductListFilterByCategory(this.category);

  final ProductCategory category;

  @override
  List<Object?> get props => [category];
}

class ProductListFilterBySearchTerm extends ProductListFilter {
  const ProductListFilterBySearchTerm(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}
