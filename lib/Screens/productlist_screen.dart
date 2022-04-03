// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/cart_provider.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:mojatablica/Screens/cart_screen.dart';
import 'package:mojatablica/Widgets/appdrawer_widget.dart';
import 'package:mojatablica/Widgets/badge_widget.dart';
import 'package:mojatablica/Widgets/proguctsgrid_widget.dart';
import 'package:provider/provider.dart';

enum showing { showAll, showFav }

class SProductList extends StatefulWidget {
  static String routName = 'SProductList';
  @override
  State<SProductList> createState() => _SProductListState();
}

class _SProductListState extends State<SProductList> {
  bool onlyFavorite = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context, listen: false)
          .loadProducts()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print(error);
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moja Tablica"),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text("Show all"),
                      value: showing.showAll,
                    ),
                    const PopupMenuItem(
                      child: Text("Show favorite"),
                      value: showing.showFav,
                    ),
                  ],
              onSelected: (value) {
                if (value == showing.showAll)
                  onlyFavorite = false;
                else
                  onlyFavorite = true;

                setState(() {});
              }),
          Consumer<CartItems>(
            builder: (_, cartDta, iconButtonChild) => Badge(
              value: cartDta.itemsCount.toString(),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_sharp),
                onPressed: () =>
                    Navigator.of(context).pushNamed(SCart.routName),
              ),
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
      drawer: const WAppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<Products>(context, listen: false)
                    .loadProducts();
                setState(() {});
                print('cyk');
              },
              child: WGridVievItemsList(
                onlyFavorites: onlyFavorite,
              ),
            ),
    );
  }
}
