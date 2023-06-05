import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

final class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.category,
  });

  final int id;
  final String name;
  final ProductCategory category;

  @override
  List<Object?> get props => [
        id,
        name,
        category,
      ];
}
