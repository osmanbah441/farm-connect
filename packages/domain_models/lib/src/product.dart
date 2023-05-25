import 'package:equatable/equatable.dart';

final class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
