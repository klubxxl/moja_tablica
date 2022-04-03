import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/auth_provider.dart';
import 'package:mojatablica/Screens/myproducts_screen.dart';
import 'package:mojatablica/Screens/orders_screen.dart';
import 'package:provider/provider.dart';

class WAppDrawer extends StatelessWidget {
  const WAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: kLighterBackgroundColor,
      child: Column(
        children: [
          AppBar(
            title: const Text('Select Section'),
            backgroundColor: kPrimaryColor,
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop_2_outlined),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(SOrderScreen.routName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(SMyProducts.routName),
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    ));
  }
}
