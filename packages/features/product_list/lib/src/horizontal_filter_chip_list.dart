import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list/src/product_list_bloc.dart';

class HorizontalFilterChipList extends StatefulWidget {
  const HorizontalFilterChipList({super.key});

  @override
  State<HorizontalFilterChipList> createState() =>
      _HorizontalFilterChipListState();
}

class _HorizontalFilterChipListState extends State<HorizontalFilterChipList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ProductCategory.values
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BlocSelector<ProductListBloc, ProductListState,
                    ProductCategory?>(
                  selector: (state) {
                    final filter = state.filter;
                    final selectedProduct =
                        filter is ProductListFilterByCategory
                            ? filter.category
                            : null;

                    return selectedProduct;
                  },
                  builder: (context, selectedProduct) {
                    return FilterChip(
                      label: Text(category.name),
                      selected: category == selectedProduct,
                      onSelected: (isSelected) {
                        final bloc = context.read<ProductListBloc>();
                        bloc.add(ProductListCategoryChanged(
                            category: isSelected ? category : null));
                      },
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
