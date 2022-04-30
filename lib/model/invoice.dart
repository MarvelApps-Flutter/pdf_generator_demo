import 'package:flutter_pdf_apps/model/item_model.dart';

class Invoice{
  String? companyName;
  String? companyGstin;
  String? companyEmail;
  String? companyAddress;
  String? companyWebsite;
  String? imagePath;
  String? invoiceNumber;
  String? invoiceDate;
  String? clientName;
  String? clientCompanyName;
  String? clientEmail;
  String? clientContactNo;
  String? clientAddress;
  List<ItemModel>? itemList;
  String? termsAndCon;

  Invoice({this.companyName,this.companyGstin,this.companyEmail,this.companyAddress,this.invoiceNumber,this.invoiceDate,this.companyWebsite,this.imagePath,this.clientName,this.clientCompanyName,this.clientEmail,this.clientContactNo,this.clientAddress,this.itemList,this.termsAndCon});

}