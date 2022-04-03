import 'package:mojatablica/Providers/products_provider.dart';
import 'package:mojatablica/Widgets/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class WGridVievItemsList extends StatelessWidget {
  WGridVievItemsList({this.onlyFavorites = false});

  bool onlyFavorites;
  @override
  Widget build(BuildContext context) {
    final prodeuctsData = Provider.of<Products>(context);
    final products =
        onlyFavorites ? prodeuctsData.favItems : prodeuctsData.items;
    return GridView.builder(
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: WProduct(),
      ),
      // ignore: prefer_const_constructors
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10),
      itemCount: products.length,
    );
  }
}
