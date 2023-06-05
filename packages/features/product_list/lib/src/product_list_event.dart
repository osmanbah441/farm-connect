part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

final class ProductListCategoryChanged extends ProductListEvent {
  const ProductListCategoryChanged({this.category});

  final ProductCategory? category;

  @override
  List<Object?> get props => [category];
}

final class ProductListNextPageRequested extends ProductListEvent {
  const ProductListNextPageRequested(this.nextPage);

  final int nextPage;

  @override
  List<Object?> get props => [nextPage];
}

final class ProductListSearchTermChanged extends ProductListEvent {
  const ProductListSearchTermChanged(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}
