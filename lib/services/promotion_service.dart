import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantngo_frontend/providers/merchant_provider.dart';
import 'package:plantngo_frontend/providers/promotion_provider.dart';
import 'package:plantngo_frontend/utils/error_handling.dart';
import 'package:provider/provider.dart';
import '../models/promotion.dart';
import '../utils/global_variables.dart';
import 'package:http_parser/http_parser.dart';
import '../utils/user_secure_storage.dart';

class PromotionService {
  static Future<List<Promotion>> fetchAllPromotions(
      BuildContext context) async {
    String? token = await UserSecureStorage.getToken();
    List<Promotion> promotions = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/promotion/allPromoSorted'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        for (var i = 0; i < jsonDecode(res.body).length; i++) {
          promotions.add(Promotion.fromJson(jsonDecode(res.body)[i]));
        }
        // print(promotions);
      }
    } catch (e) {
      print(e);
      //to do catch exception
    }
    return promotions;
  }

  static Future<List<Promotion>> fetchAllPromotionsByMerchant(
      BuildContext context) async {
    String? token = await UserSecureStorage.getToken();

    MerchantProvider merchantProvider =
        Provider.of<MerchantProvider>(context, listen: false);
    List<Promotion> promotions = [];

    try {
      http.Response res = await http.get(
        Uri.parse(
            '$uri/api/v1/promotion/${merchantProvider.merchant.username}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      if (res.statusCode == 200) {
        for (var i = 0; i < res.body.length; i++) {
          promotions.add(Promotion.fromJson(jsonDecode(res.body)[i]));
        }
      }
    } catch (e) {
      //to do catch exception
    }
    return promotions;
  }

  static Future createPromotion(
      {required BuildContext context,
      required String description,
      required String startDate,
      required String endDate,
      required File image}) async {
    String? token = await UserSecureStorage.getToken();

    MerchantProvider merchantProvider =
        Provider.of<MerchantProvider>(context, listen: false);
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$uri/api/v1/promotion/${merchantProvider.merchant.username}'))
        ..files.add(await http.MultipartFile.fromPath('image', image.path,
            contentType: MediaType("*", "*")))
        ..files.add(http.MultipartFile.fromString(
            'promotion',
            jsonEncode({
              "description": description,
              "endDate": endDate,
              "startDate": startDate
            }),
            contentType: MediaType("application", "json")))
        ..headers.addAll({
          "Accept": '*/*',
          "Authorization": 'Bearer $token',
        });

      var streamedRes = await request.send();

      var res = await http.Response.fromStream(streamedRes);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Promotion Created",
          );
        },
      );
    } catch (e) {
      //todo
    }
  }

  static Future deletePromotion(
      {required BuildContext context, required int promotionId}) async {
    String? token = await UserSecureStorage.getToken();
    try {
      http.Response res = await http.delete(
          Uri.parse('$uri/api/v1/promotion/$promotionId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Promotion deleted",
          );
        },
      );
    } catch (e) {
      //todo
      print(e);
    }
  }

  static Future addClicks(
      {required BuildContext context, required int promotionId}) async {
    String? token = await UserSecureStorage.getToken();
    try {
      http.Response res = await http.put(
          Uri.parse('$uri/api/v1/promotion/addClick/$promotionId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          PromotionProvider promotionProvider =
              Provider.of<PromotionProvider>(context, listen: false);
          promotionProvider.setPromotions(context);
        },
      );
    } catch (e) {
      //todo
      // print(e);
    }
  }

  static Future editPromotion(
      {required BuildContext context,
      required int promotionId,
      required File? image,
      required String description,
      required String startDate,
      required String endDate}) async {
    String? token = await UserSecureStorage.getToken();

    MerchantProvider merchantProvider =
        Provider.of<MerchantProvider>(context, listen: false);
    try {
      // http.Response res =
      //     await http.put(Uri.parse('$uri/api/v1/promotion/$promotionId'),
      //         headers: <String, String>{
      //           'Content-Type': 'application/json; charset=UTF-8',
      //           'Authorization': 'Bearer $token'
      //         },
      //         body: json.encode({
      //           "bannerUrl": bannerUrl,
      //           "description": description,
      //           "endDate": endDate,
      //           "startDate": startDate
      //         }));

      var request = http.MultipartRequest(
          'PUT', Uri.parse('$uri/api/v1/promotion/$promotionId'))
        ..files.add(http.MultipartFile.fromString(
            'promotion',
            jsonEncode({
              "description": description,
              "endDate": endDate,
              "startDate": startDate
            }),
            contentType: MediaType("application", "json")))
        ..headers.addAll({
          "Accept": '*/*',
          "Authorization": 'Bearer $token',
        });

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path,
            contentType: MediaType("*", "*")));
      }

      var streamedRes = await request.send();

      var res = await http.Response.fromStream(streamedRes);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Promotion Updated",
          );
        },
      );
    } catch (e) {
      //todo
      print(e);
    }
  }
}
