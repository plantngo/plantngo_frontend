import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'merchant.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  int? id;
  String? name;
  String? description;
  int value;
  String? type;
  double? discount;
  int? merchantId;

  Voucher(
      {required this.id,
      required this.description,
      required this.value,
      required this.discount,
      required this.type,
      required this.merchantId});
  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  bool operator ==(o) =>
      o is Voucher && id == o.id && merchantId == o.merchantId;
  int get hashCode => hash2(id.hashCode, merchantId.hashCode);
}
