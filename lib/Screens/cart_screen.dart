import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/cart_provider.dart';
import 'package:mojatablica/Providers/order_provider.dart';
//import 'package:mojatablica/Widgets/appdrawer_widget.dart';
import 'package:mojatablica/Widgets/cartitem_widget.dart';
import 'package:provider/provider.dart';

class SCart extends StatelessWidget {
  static const String routName = "SCart";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartItems>(context);
    final totalAmmount = cartItems.priceOfProducts;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: kPrimaryColor,
      ),
      // drawer: WAppDrawer(),
      body: Column(
        children: [
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => WCartItem(
                        cartItems.cartItems.keys.toList()[index],
                        cartItems.cartItems.values.toList()[index].title,
                        cartItems.cartItems.values.toList()[index].price,
                        cartItems.cartItems.values.toList()[index].count),
                    itemCount: cartItems.cartItems.length,
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          Card(
            color: kLighterBackgroundColor,
            elevation: 5,
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Total:   $totalAmmount\$",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text(
                        "Order now",
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                      ),
                      onPressed: (totalAmmount <= 0 || _isLoading)
                          ? null
                          : () async {
                              _isLoading = true;
                              await Provider.of<OrderItems>(context,
                                      listen: false)
                                  .addOrder(cartItems.cartItems.values.toList(),
                                      totalAmmount);
                              cartItems.clear();
                              _isLoading = false;
                            },
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
