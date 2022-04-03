import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:mojatablica/Screens/addProduct_screen.dart';
import 'package:mojatablica/Widgets/appdrawer_widget.dart';
import 'package:mojatablica/Widgets/myproduct_widget.dart';
import 'package:provider/provider.dart';

class SMyProducts extends StatelessWidget {
  static const String routName = 'SMyProducts';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).loadProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My products'),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(SAddProduct.routName),
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const WAppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height - 16,
                      child: Consumer<Products>(
                        builder: (context, products, child) => ListView(
                          children: products.items
                              .map((e) => WMyProduct(e.title, e.imageUrl, e.id))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
