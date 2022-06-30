import 'package:flutter/material.dart';
import 'package:flutter_pdf_apps/model/landing_item.dart';
import 'package:flutter_pdf_apps/utils/text_styles.dart';
import 'create_invoice_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<LandingItem> landingList = [
    LandingItem(
      showNumber: "1",
      title: "Add Your Details",
      description: "Enter your company's address",
    ),
    LandingItem(
      showNumber: "2",
      title: "Add Your Client's Details",
      description: "Enter client's address ",),
    LandingItem(
      showNumber: "3",
      title: "Choose an Option",
      description: "Share, Download, or Email Invoice ",),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: buildBody()// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildBody()
  {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildTopHeader(),
              const SizedBox(height: 15,),
              buildLandingList(),
              buildCreateNewInvoiceButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopHeader()
  {
    return   const Align(
      alignment: Alignment.center,
      child: Text(
        'Create a \n professional looking invoice \n in seconds',
        style: AppTextStyles.regularForLargeTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildLandingList()
  {
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return  buildLandingItem(index, landingList);
        });
  }

  Widget buildCreateNewInvoiceButton()
  {
    return ElevatedButton.icon(
      icon: const Text('Create Invoice Now'),
      style: ElevatedButton.styleFrom(
        primary: Colors.indigoAccent.shade700,
        padding: const EdgeInsets.all(10),
        textStyle: AppTextStyles.regularForWhiteSmallTextStyle,),
      label: const Icon(Icons.arrow_forward, size: 16),
      onPressed: () {
        print("on pressed");
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()));
      },
    );
  }

  Widget buildLandingItem(int index , List<LandingItem> landingList) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4,14,4,14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Card(
              elevation: 10,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children:  [
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          landingList[index].title!,
                          style: AppTextStyles.mediumTextStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          landingList[index].description!,
                          style: AppTextStyles.regularForSmallTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.indigoAccent.shade700,
                child: Center(
                  child: Text(
                    landingList[index].showNumber!,
                    style: AppTextStyles.regularForWhiteSmallTextStyle,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
