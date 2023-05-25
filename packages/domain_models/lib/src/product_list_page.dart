import 'package:domain_models/src/product.dart';
import 'package:equatable/equatable.dart';

final class ProductListPage extends Equatable {
  const ProductListPage({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<Product> productList;

  @override
  List<Object?> get props => [isLastPage, productList];
}
