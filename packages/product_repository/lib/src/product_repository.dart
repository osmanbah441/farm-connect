import 'package:domain_models/domain_models.dart';

final _data = [
  Product(id: 1, name: "vegatable", category: ProductCategory.cat1),
  Product(id: 2, name: "fruits", category: ProductCategory.cat2),
  Product(id: 3, name: "cereals", category: ProductCategory.cat3),
  Product(id: 4, name: "beverages", category: ProductCategory.cat4),
  Product(id: 5, name: "seeds", category: ProductCategory.cat5),
];

final class ProductRepository {
  Stream<ProductListPage> fetchProductListPage(int page,
      {required ProductListFetchPolicy fetchPolicy,
      ProductCategory? category,
      String searchTerm = ''}) async* {
    final isCategory = category != null;
    final isSearching = searchTerm.isNotEmpty;

    if (isCategory && isSearching) {
      // TODO: redo with assert and end the function
      throw EmptySearchResultException();
    }

    if (isCategory) {
      final data =
          _data.where((product) => product.category == category).toList();

      yield ProductListPage(isLastPage: true, productList: data);
      return;
    }

    if (isSearching) {
      final data = _data.where((p) => p.name.contains(searchTerm)).toList();
      yield ProductListPage(isLastPage: true, productList: data);
      return;
    }

    yield ProductListPage(isLastPage: true, productList: _data);
  }
}

enum ProductListFetchPolicy {
  networkOnly,
  cacheAndNetwork,
  cachePreferably,
}
