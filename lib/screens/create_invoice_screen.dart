import 'dart:io';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_apps/mixins/validate_mixin.dart';
import 'package:flutter_pdf_apps/model/client_model.dart';
import 'package:flutter_pdf_apps/model/company_model.dart';
import 'package:flutter_pdf_apps/model/invoice.dart';
import 'package:flutter_pdf_apps/model/item_model.dart';
import 'package:flutter_pdf_apps/screens/item_details_screen.dart';
import 'package:flutter_pdf_apps/utils/text_styles.dart';
import 'package:flutter_pdf_apps/widgets/invoice_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final CompanyModel? companyModel;
  final ClientModel? clientModel;
  const CreateInvoiceScreen({Key? key, this.companyModel, this.clientModel})
      : super(key: key);

  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  // for expansion tile global key
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardC = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardD = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardE = GlobalKey();

  // for controllers
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyGstinController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController invoiceDateController = TextEditingController();
  TextEditingController clientCompanyNameController = TextEditingController();
  TextEditingController clientEmailController = TextEditingController();
  TextEditingController clientPhoneNumberController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientAddressController = TextEditingController();
  //TextEditingController notesController = TextEditingController();
  TextEditingController termsAndConController = TextEditingController();

  // controllers value
  String? compName;
  String? compGstin;
  String? compEmail;
  String? compAddress;
  String? compWebsite;
  String? imgPath;
  String? invDate;
  String? invNum;
  String? cliName;
  String? cliCompName;
  String? cliEmail;
  String? cliContactNo;
  String? cliAddress;
  String? termAndCon;

  List<ItemModel> itemsList = [];
  File? imageFile;
  final formGlobalKey = GlobalKey<FormState>();
  Map<int, Color> color = {
    50: const Color(0xFF007cff),
    100: const Color(0xFF007cff),
    200: const Color(0xFF007cff),
    300: const Color(0xFF007cff),
    400: const Color(0xFF007cff),
    500: const Color(0xFF007cff),
    600: const Color(0xFF007cff),
    700: const Color(0xFF007cff),
    800: const Color(0xFF007cff),
    900: const Color(0xFF007cff),
  };

  @override
  void initState() {
    formatDate();
    super.initState();
  }

  DateTime _currentDate = DateTime.now();
  Future _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(0xFF007cff, color),
              primaryColorDark: const Color(0xFF007cff),
              accentColor: const Color(0xFF007cff),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        formatDate();
      });
    }
  }

  void formatDate() {
    final DateFormat formatter = DateFormat('dd/MMM/yyyy');
    final String formatted = formatter.format(_currentDate);
    invoiceDateController.value = TextEditingValue(text: formatted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ItemModel.serialNo = 0;
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: <Widget>[
            buildCompanyDetailsExpansionCard(),
            buildInvoiceDetailsExpansionCard(),
            buildClientDetailsExpansionCard(),
            buildItemDetailsExpansionCard(),
            buildTermsAndConExpansionCard(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
        iconSize: 24,
        color: Colors.black,
      ),
      title: const Center(
        child: Text(
          "Create Invoice",
          style: AppTextStyles.mediumBlack54TextStyle,
        ),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 15),
          onPressed:
          //imageFile != null? () 
          (){
            
            if (formGlobalKey.currentState!.validate()) {
              compName = companyNameController.text.toString().trim();
              compGstin = companyGstinController.text.toString().trim();
              compEmail = companyEmailController.text.toString().trim();
              compAddress = companyAddressController.text.toString().trim();
              compWebsite = companyWebsiteController.text.toString().trim();
              imgPath = "";
              //imageFile!.path;
              invDate = invoiceDateController.text.toString().trim();
              invNum = invoiceNumberController.text.toString().trim();
              cliName = clientNameController.text.toString().trim();
              cliCompName = clientCompanyNameController.text.toString().trim();
              cliEmail = clientEmailController.text.toString().trim();
              cliContactNo = clientPhoneNumberController.text.toString().trim();
              cliAddress = clientAddressController.text.toString().trim();
              termAndCon = termsAndConController.text.toString().trim();
              if (compName!.length != 0 &&
                  compGstin!.length != 0 &&
                  compEmail!.length != 0 &&
                  compAddress!.length != 0 &&
                  compWebsite!.length != 0 &&
                 // imgPath!.length != 0 &&
                  invDate!.length != 0 &&
                  invNum!.length != 0 &&
                  cliName!.length != 0 &&
                  cliCompName!.length != 0 &&
                  cliEmail!.length != 0 &&
                  cliContactNo!.length != 0 &&
                  cliAddress!.length != 0 &&
                  termAndCon!.length != 0) {
                var model = Invoice(
                  companyName: compName,
                  companyGstin: compGstin,
                  companyEmail: compEmail,
                  companyAddress: compAddress,
                  companyWebsite: compWebsite,
                  imagePath: "",
                  //imageFile!.path,
                  invoiceDate: invDate,
                  invoiceNumber: invNum,
                  clientName: cliName,
                  clientCompanyName: cliCompName,
                  clientEmail: cliEmail,
                  clientContactNo: cliContactNo,
                  clientAddress: cliAddress,
                  itemList: itemsList,
                  termsAndCon: termAndCon,
                );
                print("save called");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InvoiceBuilder(model).buildInvoice()));
              }
            }
          },
          //:(){},
          icon: const Icon(Icons.save),
          iconSize: 24,
          color: imageFile != null?Colors.black: Colors.grey,
        )
      ],
    );
  }

  Widget buildCompanyDetailsExpansionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTileCard(
        expandedTextColor: Colors.indigoAccent.shade700,
        key: cardA,
        leading: Icon(Icons.person),
        title: Text(
          'Company Details',
          style: AppTextStyles.mediumTextStyle,
        ),
        subtitle: Text(
          "Click here to manage company details",
          style: AppTextStyles.lightTextStyle,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildCompanyNameTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildCompanyGstinTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildEmailTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildCompanyAddressTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildCompanyWebsiteTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildImagePickerField(),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildInvoiceDetailsExpansionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTileCard(
        expandedTextColor: Colors.indigoAccent.shade700,
        key: cardB,
        leading: Icon(Icons.date_range),
        title: Text(
          'Invoice Details',
          style: AppTextStyles.mediumTextStyle,
        ),
        subtitle: Text(
          "Click here to manage invoice number and date",
          style: AppTextStyles.lightTextStyle,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildInvoiceNumberTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildInvoiceDateTextField(),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildClientDetailsExpansionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTileCard(
        key: cardC,
        expandedTextColor: Colors.indigoAccent.shade700,
        leading: Icon(Icons.supervised_user_circle_sharp),
        title: Text(
          'Client Details',
          style: AppTextStyles.mediumTextStyle,
        ),
        subtitle: Text(
          "Click here to manage the list of clients",
          style: AppTextStyles.lightTextStyle,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildClientNameTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildClientCompanyNameTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildClientEmailTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildClientPhoneTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    buildAddressTextField(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildItemDetailsExpansionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTileCard(
        key: cardD,
        expandedTextColor: Colors.indigoAccent.shade700,
        leading: Icon(Icons.shopping_cart),
        title: Text(
          'Item Details',
          style: AppTextStyles.mediumTextStyle,
        ),
        subtitle: Text(
          "Click here to manage items",
          style: AppTextStyles.lightTextStyle,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.indigoAccent.shade700,
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Add New product")
                          ],
                        ),
                        onTap: () async {
                          var itemListData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemDetailsScreen()));
                          setState(() {
                            if (itemListData != null) {
                              print("itemListData is $itemListData");
                              itemsList.add(itemListData);
                            }
                          });
                          print("itemsList is ${itemsList[0].productName}");
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    itemsList.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: itemsList.length,
                            itemBuilder: (context, index) {
                              ItemModel model = itemsList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.productName!),
                                        Text(model.rate!)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container()
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildTermsAndConExpansionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ExpansionTileCard(
        key: cardE,
        expandedTextColor: Colors.indigoAccent.shade700,
        leading: Icon(Icons.analytics_outlined),
        title: Text(
          'Terms and Conditions Details',
          style: AppTextStyles.mediumTextStyle,
        ),
        subtitle: Text(
          "Click here to manage the terms and conditions displayed",
          style: AppTextStyles.lightTextStyle,
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          // InkWell(
          //   child:
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildTermsAndConTextField(),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildImagePickerField() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigoAccent.shade700,
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text("Select Image"),
            SizedBox(
              width: 15,
            ),
            imageFile != null
                ? Container(
                    width: 140,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(imageFile!),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        onTap: () async {
          _showImagePicker(context);
        },
      ),
    );
  }

  Widget buildCompanyNameTextField() {
    return TextFormField(
      controller: companyNameController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Company Name",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Company Name";
        }
      },
    );
  }

  Widget buildCompanyGstinTextField() {
    return TextFormField(
      controller: companyGstinController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter GSTIN",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (isGstinValid(value!)) {
          return null;
        } else {
          return 'Enter a valid GSTIN';
        }
      },
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: companyEmailController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Email",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (email) {
        if (isEmailValid(email!)) {
          return null;
        } else {
          return 'Enter a valid email address';
        }
      },
    );
  }

  Widget buildCompanyAddressTextField() {
    return TextFormField(
      controller: companyAddressController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Company Address",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Company Address";
        }
      },
    );
  }

  Widget buildCompanyWebsiteTextField() {
    return TextFormField(
      controller: companyWebsiteController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Company Website",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Company Website";
        }
      },
    );
  }

  Widget buildInvoiceNumberTextField() {
    return TextFormField(
      controller: invoiceNumberController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Invoice Number",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Invoice Number";
        }
      },
    );
  }

  Widget buildInvoiceDateTextField() {
    return TextFormField(
      controller: invoiceDateController,
      onTap: () async {
        await _selectDueDate(context);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      cursorColor: Colors.black,
      autofocus: false,
      readOnly: true,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.grey,
        ),
        labelText: "Enter Due Date",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );
  }

  Widget buildClientNameTextField() {
    return TextFormField(
      controller: clientNameController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Name",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Client Name";
        }
      },
    );
  }

  Widget buildClientCompanyNameTextField() {
    return TextFormField(
      controller: clientCompanyNameController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Company Name",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return "Enter Client's Company Name";
        }
      },
    );
  }

  Widget buildClientEmailTextField() {
    return TextFormField(
      controller: clientEmailController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Email",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (email) {
        if (isEmailValid(email!)) {
          return null;
        } else {
          return 'Enter a valid email address';
        }
      },
    );
  }

  Widget buildClientPhoneTextField() {
    return TextFormField(
      controller: clientPhoneNumberController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Contact Number",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );
  }

  Widget buildAddressTextField() {
    return TextFormField(
      controller: clientAddressController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Address",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'Enter Address';
        }
      },
    );
  }

  Widget buildTermsAndConTextField() {
    return TextFormField(
      controller: termsAndConController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        isDense: true,
        labelText: "Enter Terms and conditions",
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
      validator: (value) {
        if (value!.isNotEmpty) {
          return null;
        } else {
          return 'Enter Terms and Conditions';
        }
      },
    );
  }

  _showImagePicker(BuildContext context) async {
    var pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    setState(() {
      imageFile = File(pickedImage!.path);
      print("imageFile is $imageFile");
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
