import 'package:flutter/material.dart';
import 'package:flutter_pdf_apps/model/item_model.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({Key? key}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    ));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: formGlobalKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              buildProductNameTextField(),
              SizedBox(
                height: 10,
              ),
              buildRateTextField(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Icon(Icons.arrow_back_ios,color: Colors.black,),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: const Center(
        child: Text(
          "Item Details",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 15),
          onPressed: () {
            String productName = productNameController.text.toString().trim();
            String rate = rateController.text.toString().trim();
            if (formGlobalKey.currentState!.validate()) {
              if (productName.length != 0 && rate.length != 0) {
                var model = ItemModel(productName: productName, rate: rate);
                Navigator.pop(context, model);
              }
            }
          },
          icon: const Icon(Icons.save),
          iconSize: 24,
          color: Colors.black,
        )
      ],
    );
  }

  Widget buildProductNameTextField() {
    return TextFormField(
      controller: productNameController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: "Enter Product Name",
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
          return "Enter Product Name";
        }
      },
    );
  }

  Widget buildRateTextField() {
    return TextFormField(
      controller: rateController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: "Enter Rate",
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
          return "Enter Rate";
        }
      },
    );
  }
}
