import 'package:flutter/material.dart';
import 'package:mojatablica/Providers/auth_provider.dart';
import 'package:mojatablica/Providers/cart_provider.dart';
import 'package:mojatablica/Providers/order_provider.dart';
import 'package:provider/provider.dart';

import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/product_model.dart';
import 'package:mojatablica/Screens/productdetail_screen.dart';

class WProduct extends StatelessWidget {
  // String id;
  // String title;
  // String ImageURL;

  // WProduct(this.title, this.ImageURL, this.id);

  @override
  Widget build(BuildContext context) {
    double widthOfDevice = MediaQuery.of(context).size.width;
    final item = Provider.of<Product>(context);
    final cartItem = Provider.of<CartItems>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(SProductDetail.routName, arguments: item.id),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: widthOfDevice / 2,
          width: widthOfDevice / 3 - 20,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Stack(
            children: [
              Hero(
                tag: item.id,
                child: SizedBox(
                  height: widthOfDevice / 2,
                  width: widthOfDevice / 2,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/loadingImage.png'),
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: kBackgroundColor.withOpacity(0.5)),
                alignment: Alignment.bottomCenter,
                height: 40,
                padding: const EdgeInsets.only(
                    left: 2, right: 2, bottom: 1 / 3, top: 1 / 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => {
                        cartItem.addCardItem(item.id, item.title, item.price),
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Item added to cart!'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              Provider.of<CartItems>(context, listen: false)
                                  .removeSingleProduct(item.id);
                            },
                          ),
                        ))
                      },
                      icon: const Icon(Icons.shopping_bag),
                      color: Colors.brown[800],
                    ),
                    SizedBox(
                      width: (widthOfDevice / 3 - 20) * 57 / 100,
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.brown[900]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        item.changeIsFavorite(
                            Provider.of<Auth>(context, listen: false)
                                        .getToken !=
                                    null
                                ? Provider.of<Auth>(context, listen: false)
                                    .getToken as String
                                : '',
                            Provider.of<Auth>(context, listen: false)
                                        .getUserId !=
                                    null
                                ? Provider.of<Auth>(context, listen: false)
                                    .getUserId as String
                                : ''),
                      },
                      icon: Icon(item.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border),
                      color: Colors.brown[800],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
