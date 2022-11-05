import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:plantngo_frontend/models/order.dart';
import 'package:plantngo_frontend/screens/customer/cart/cart_order_list.dart';
import 'package:plantngo_frontend/services/customer_order_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Order>> futureCustomerOrders;
  List<bool> orderSelectedArr = [];
  double totalPrice = 0;

  double calculateTotal(List<Order> orders) {
    double total = 0.0;
    for (int i = 0; i < orders.length; i++) {
      if (orderSelectedArr[i]) {
        total += orders[i].totalPrice!;
      }
    }
    return total;
  }

  onCheckboxChanged(bool newValue, int i) {
    setState(() {
      orderSelectedArr[i] = newValue;
    });
    futureCustomerOrders.then((value) {
      setState(() {
        totalPrice = calculateTotal(value);
      });
    });
  }

  void retrieveAllOrders() {
    setState(() {
      futureCustomerOrders =
          CustomerOrderService.getAllOrdersByCustomerAndOrderStatus(
        context: context,
        orderStatus: "CREATED",
      );
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FutureBuilder<List<Order>>(
        future: futureCustomerOrders,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load page"),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          orderSelectedArr.where((element) => element).isEmpty
                              ? Colors.grey
                              : Colors.green)),
                  onPressed:
                      orderSelectedArr.where((element) => element).isEmpty
                          ? null
                          : () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${orderSelectedArr.where((element) => element).length} order(s)",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.shopping_bag_outlined, size: 20.0),
                          Text("Checkout Cart"),
                        ],
                      ),
                      Text(
                        "S\$ ${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const SizedBox();
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     boxShadow: const [
        //       BoxShadow(
        //         color: Colors.grey,
        //         offset: Offset(0, 2.0),
        //         blurRadius: 4.0,
        //       )
        //     ],
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         Colors.green.shade200,
        //         Colors.green.shade300,
        //         Colors.green,
        //       ],
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<List<Order>>(
              future: futureCustomerOrders,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load page"),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(
                          thickness: 5,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      final result = snapshot.data![index];
                      orderSelectedArr.add(false);
                      return CartOrderList(
                        order: result,
                        selected: orderSelectedArr[index],
                        index: index,
                        onCheckboxChanged: onCheckboxChanged,
                        refreshHook: retrieveAllOrders,
                      );
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("You have nothing in your cart!"),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
