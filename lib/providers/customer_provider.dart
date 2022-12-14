import 'dart:convert';

import '../models/customer.dart';
import 'package:flutter/material.dart';

import '../models/voucher.dart';
import '../services/customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  Customer _customer = Customer(
    id: null,
    username: '',
    email: '',
    token: '',
    greenPoints: 0,
    preference: [],
    ownedVouchers: [],
    vouchersCart: [],
  );

  Customer get customer => _customer;

  void setCustomer(String customer, String token) {
    Map<String, dynamic> customerMap = jsonDecode(customer);
    customerMap['token'] = token;
    _customer = Customer.fromJson(customerMap);
    notifyListeners();
  }

  void setCustomerFromModel(Customer customer) {
    _customer = customer;
    notifyListeners();
  }

  void resetCustomer() {
    _customer = Customer(
      id: null,
      username: '',
      email: '',
      token: '',
      greenPoints: 0,
      preference: [],
      ownedVouchers: [],
      vouchersCart: [],
    );
  }

  void setVoucherCart(BuildContext context) async {
    customer.vouchersCart =
        await CustomerService.fetchAllVouchersInCart(context);
    notifyListeners();
  }

  void addVouchersToCart(BuildContext context, Voucher v) {
    CustomerService.addVoucherToCart(context, v);
    customer.vouchersCart.add(v);
    notifyListeners();
  }

  void removeVouchersFromCart(BuildContext context, Voucher v) {
    CustomerService.removeVoucherFromCart(context, v);
    customer.vouchersCart.remove(v);
    notifyListeners();
  }

  void emptyCart() {
    customer.vouchersCart = [];
    notifyListeners();
  }

  void useVoucher(BuildContext context, Voucher v) {
    CustomerService.useVoucher(context, v);
    customer.ownedVouchers.remove(v);
    notifyListeners();
  }
}
