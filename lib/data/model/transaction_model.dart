import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tt_jig_ms/helper/helper.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionRequestModel {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "trDate")
  final String date;

  @JsonKey(name: "menuTrans")
  final String menu;

  @JsonKey(name: "typeDest")
  final String type;

  TransactionRequestModel({
    required this.page,
    required this.date,
    required this.menu,
    required this.type,
  });

  factory TransactionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionRequestModelToJson(this);
}

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: "RN")
  final String? rnNumber;
  @JsonKey(name: "TRANS_ID")
  final String? transactionID;
  @JsonKey(name: "TRANS_TYPE_ID")
  final String? transactionTypeID;
  @JsonKey(name: "LABEL_TYPE")
  final String? labelType;
  @JsonKey(name: "LABEL_ID")
  final String? labelID;
  @JsonKey(name: "DATA_SOURCE")
  final String? dataSource;
  @JsonKey(name: "LOCATION")
  final String? location;
  @JsonKey(name: "LOCATION_NEW")
  final String? newLocation;
  @JsonKey(name: "CREATED_BY")
  final String? createdBy;
  @JsonKey(name: "CREATION_DATE")
  final String? createdAt;
  @JsonKey(name: "DEV_ITEM_CODE")
  final String? devItemCode;
  @JsonKey(name: "SIZE_CD")
  final String? sizeCD;
  @JsonKey(name: "ALIAS_TOOLING")
  final String? toolingAlias;
  @JsonKey(name: "ALIAS_MODEL")
  final String? modelAlias;
  @JsonKey(name: "ALIAS_PART")
  final String? partAlias;
  @JsonKey(name: "STYLE")
  final String? style;
  @JsonKey(name: "NK_CODE")
  final String? nikeCode;

  TransactionModel({
    this.transactionID,
    this.rnNumber,
    this.transactionTypeID,
    this.labelType,
    this.labelID,
    this.dataSource,
    this.location,
    this.newLocation,
    this.createdBy,
    this.createdAt,
    this.devItemCode,
    this.sizeCD,
    this.toolingAlias,
    this.modelAlias,
    this.partAlias,
    this.style,
    this.nikeCode,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  Icon get getIcon {
    String type = transactionsTypeIDs.first;
    IconData icon;
    Color color;

    switch (type.toUpperCase()) {
      case 'IN':
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      case 'OUT':
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case 'MOVE':
        icon = Icons.swap_horiz;
        color = Colors.blue;
        break;
      case 'RET':
        icon = Icons.restore_page_outlined;
        color = Colors.red;
        break;
      case 'DES':
        icon = Icons.delete_forever_outlined;
        color = Colors.grey;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 20);
  }

  String get transactionType => transactionsTypeIDs.last;
  String get description => [
    toolingAlias ?? "",
    modelAlias ?? "",
    partAlias ?? "",
  ].whereNot((element) => element.isEmpty).join(", ");
  List<String> get transactionsTypeIDs => (transactionTypeID ?? "").split("_");
  String? get transactionCode =>
      transactionID?.extractStringInBrackets(prefix: "#", sufix: "-");
  String? get from => transactionID?.extractStringInBrackets();
  String? get labelCode => labelID?.split(" ").first;
  String? get itemCode => labelID?.extractStringInBrackets();
  String? get box => labelID?.extractStringInBrackets(prefix: "[", sufix: "]");
}

@JsonSerializable()
class CreateTransactionRequestModel {
  // Out
  @JsonKey(name: "senderId") // out, return, destroy
  final String? senderID;
  @JsonKey(name: "receiverId") // out, return,  destroy
  final String? receiverID;
  @JsonKey(name: "dept") // out, return, destroy
  final String? department;
  @JsonKey(name: "wo") // out
  final String? workingNumber;
  @JsonKey(name: "labelList") // move, out, return, destroy
  final String? transactionDetail;
  @JsonKey(name: "userId") // move, out, return, destroy
  final String? userID;
  @JsonKey(name: "transDetail") // out
  final String? transactionDate;

  // Return || Destroy
  @JsonKey(name: "reason") // return, destroy
  final String? reason;
  @JsonKey(name: "returnType") // return, destroy
  final String? returnType;
  @JsonKey(name: "brokenDate") // return, destroy
  final String? brokenDate;

  // Move
  @JsonKey(name: "labelId")
  final String? labelID; // move

  CreateTransactionRequestModel({
    this.senderID,
    this.receiverID,
    this.department,
    this.workingNumber,
    this.transactionDetail,
    this.userID,
    this.transactionDate,
    this.reason,
    this.returnType,
    this.brokenDate,
    this.labelID,
  });

  factory CreateTransactionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionRequestModelToJson(this);
}
