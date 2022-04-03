import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:mojatablica/Screens/addproduct_screen.dart';
import 'package:provider/provider.dart';

class WMyProduct extends StatelessWidget {
  WMyProduct(this.title, this.imageUrl, this.id);
  final String title, imageUrl, id;
  @override
  Widget build(BuildContext context) {
    final scaffoldMsg = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(SAddProduct.routName, arguments: id);
                  },
                  icon: const Icon(Icons.edit),
                  color: kSecondaryColor,
                ),
                IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .removeById(id);
                      } catch (error) {
                        scaffoldMsg.showSnackBar(SnackBar(
                            content: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        )));
                      }
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red)
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
