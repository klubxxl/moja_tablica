import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/order_provider.dart';

class WOrderItem extends StatefulWidget {
  final OrderItem orderItem;
  WOrderItem(this.orderItem);

  @override
  State<WOrderItem> createState() => _WOrderItemState();
}

class _WOrderItemState extends State<WOrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.orderItem.products.length * 110.0 + 200, 200)
          : 100,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            tileColor: kLighterBackgroundColor,
            title: Text(widget.orderItem.amount.toString() + '\$'),
            subtitle: Text(
              DateFormat('dd MM yyyy').format(widget.orderItem.date),
            ),
            trailing: IconButton(
                onPressed: () => {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      })
                    },
                icon: _isExpanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: kLighterBackgroundColor,
            margin: const EdgeInsets.all(10),
            height: _isExpanded
                ? min(widget.orderItem.products.length * 20.0 + 10, 100)
                : 0,
            child: ListView(
              children: widget.orderItem.products
                  .map((e) => Row(
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            'x' + e.count.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          const Spacer(),
                          Text(e.price.toString() + '\$',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                        ],
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
