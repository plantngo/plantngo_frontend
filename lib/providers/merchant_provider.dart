import 'dart:convert';
import 'package:plantngo_frontend/models/voucher.dart';

import '../models/merchant.dart';
import 'package:flutter/material.dart';

class MerchantProvider extends ChangeNotifier {
  Merchant _merchant = Merchant(
      id: null,
      username: '',
      email: '',
      token: '',
      company: '',
      categories: [],
      vouchers: []);

  Merchant get merchant => _merchant;

  void setMerchant(String merchant, String token) {
    Map<String, dynamic> merchantMap = jsonDecode(merchant)[0];
    merchantMap['token'] = token;
    _merchant = Merchant.fromJSON(merchantMap);
    notifyListeners();
  }

  void setMerchantFromModel(Merchant merchant) {
    _merchant = merchant;
    notifyListeners();
  }

  void setVouchers(List<Voucher> vouchers) {
    _merchant.vouchers = vouchers;
    notifyListeners();
  }

  void resetMerchant() {
    _merchant = Merchant(
      id: null,
      username: '',
      email: '',
      token: '',
      company: '',
      categories: [],
      vouchers: [],
    );
  }
}
