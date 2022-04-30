class ItemModel
{
  static int serialNo = 0;
  int id = 0;
  String? productName;
  String? rate;

  ItemModel({this.productName, this.rate})
  {
    serialNo++;
    this.id = serialNo;
    this.productName = productName;
    this.rate = rate;
  }

  dynamic getIndex(int index) {
    print("id is $id");


    switch (index) {

      case 0:
        return id;
      case 1:
        return productName.toString();
      case 2:
        return rate.toString();

      default:
        return "";
    }
  }
}