import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/cart_provider.dart' show CartItems;
import 'package:provider/provider.dart';

class WCartItem extends StatelessWidget {
  WCartItem(this.cartId, this.title, this.price, this.count);
  String cartId;
  String title;
  double price;
  int count;

  @override
  Widget build(BuildContext context) {
    final CartItemsProvider = Provider.of<CartItems>(context);
    return Dismissible(
      key: ValueKey(cartId),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(bottom: 4, top: 4, left: 6, right: 6),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.delete,
            color: Colors.black,
            size: 40,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 4, left: 6, right: 6),
        child: Card(
          color: kBackgroundColor,
          shadowColor: Colors.black,
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '$price\$',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )),
            ),
            title: Text(title),
            trailing:
                Text('x$count', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Total: ${(price * count)}\$',
            ),
          ),
        ),
      ),
      onDismissed: (direction) => CartItemsProvider.removeById(cartId),
    );
  }
}
