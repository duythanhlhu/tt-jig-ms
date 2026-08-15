// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequestModel _$TransactionRequestModelFromJson(
        Map<String, dynamic> json) =>
    TransactionRequestModel(
      page: json['page'] as int,
      date: json['trDate'] as String,
      menu: json['menuTrans'] as String,
      type: json['typeDest'] as String,
    );

Map<String, dynamic> _$TransactionRequestModelToJson(
        TransactionRequestModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'trDate': instance.date,
      'menuTrans': instance.menu,
      'typeDest': instance.type,
    };

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      transactionID: json['TRANS_ID'] as String?,
      rnNumber: json['RN'] as String?,
      transactionTypeID: json['TRANS_TYPE_ID'] as String?,
      labelType: json['LABEL_TYPE'] as String?,
      labelID: json['LABEL_ID'] as String?,
      dataSource: json['DATA_SOURCE'] as String?,
      location: json['LOCATION'] as String?,
      newLocation: json['LOCATION_NEW'] as String?,
      createdBy: json['CREATED_BY'] as String?,
      createdAt: json['CREATION_DATE'] as String?,
      devItemCode: json['DEV_ITEM_CODE'] as String?,
      sizeCD: json['SIZE_CD'] as String?,
      toolingAlias: json['ALIAS_TOOLING'] as String?,
      modelAlias: json['ALIAS_MODEL'] as String?,
      partAlias: json['ALIAS_PART'] as String?,
      style: json['STYLE'] as String?,
      nikeCode: json['NK_CODE'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'RN': instance.rnNumber,
      'TRANS_ID': instance.transactionID,
      'TRANS_TYPE_ID': instance.transactionTypeID,
      'LABEL_TYPE': instance.labelType,
      'LABEL_ID': instance.labelID,
      'DATA_SOURCE': instance.dataSource,
      'LOCATION': instance.location,
      'LOCATION_NEW': instance.newLocation,
      'CREATED_BY': instance.createdBy,
      'CREATION_DATE': instance.createdAt,
      'DEV_ITEM_CODE': instance.devItemCode,
      'SIZE_CD': instance.sizeCD,
      'ALIAS_TOOLING': instance.toolingAlias,
      'ALIAS_MODEL': instance.modelAlias,
      'ALIAS_PART': instance.partAlias,
      'STYLE': instance.style,
      'NK_CODE': instance.nikeCode,
    };

CreateTransactionRequestModel _$CreateTransactionRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionRequestModel(
      senderID: json['senderId'] as String?,
      receiverID: json['receiverId'] as String?,
      department: json['dept'] as String?,
      workingNumber: json['wo'] as String?,
      transactionDetail: json['labelList'] as String?,
      userID: json['userId'] as String?,
      transactionDate: json['transDetail'] as String?,
      reason: json['reason'] as String?,
      returnType: json['returnType'] as String?,
      brokenDate: json['brokenDate'] as String?,
      labelID: json['labelId'] as String?,
    );

Map<String, dynamic> _$CreateTransactionRequestModelToJson(
        CreateTransactionRequestModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderID,
      'receiverId': instance.receiverID,
      'dept': instance.department,
      'wo': instance.workingNumber,
      'labelList': instance.transactionDetail,
      'userId': instance.userID,
      'transDetail': instance.transactionDate,
      'reason': instance.reason,
      'returnType': instance.returnType,
      'brokenDate': instance.brokenDate,
      'labelId': instance.labelID,
    };
