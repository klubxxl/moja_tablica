import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:provider/provider.dart';

class SProductDetail extends StatelessWidget {
  static const String routName = 'SProductDetail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).selectById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedProduct.title),
          backgroundColor: kPrimaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width - 20,
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 20,
                    child: Hero(
                      tag: selectedProduct.id,
                      child: Image.network(
                        selectedProduct.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  selectedProduct.title,
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: kPrimaryColor,
                  child: FittedBox(
                    child: Text(
                      selectedProduct.price.toString() + '\$',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(selectedProduct.description)
              ],
            ),
          ),
        ));
  }
}
