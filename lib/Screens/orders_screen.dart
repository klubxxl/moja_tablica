import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/order_provider.dart';
import 'package:mojatablica/Widgets/appdrawer_widget.dart';
import 'package:mojatablica/Widgets/orederitem_widget.dart';
import 'package:provider/provider.dart';

class SOrderScreen extends StatefulWidget {
  static final String routName = 'SOrderScreen';

  @override
  State<SOrderScreen> createState() => _SOrderScreenState();
}

class _SOrderScreenState extends State<SOrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<OrderItems>(context, listen: false).loadOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvier = Provider.of<OrderItems>(context);
    final orderItems = ordersProvier.gerOrders();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Your orders'),
      ),
      drawer: const WAppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<OrderItems>(context, listen: false).loadOrders();
        },
        child: ListView.builder(
          itemCount: orderItems.length,
          itemBuilder: (context, index) => WOrderItem(orderItems[index]),
        ),
      ),
    );
  }
}
