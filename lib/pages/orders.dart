import 'dart:convert';
import 'package:emporos/apiaccess/requests.dart';
import 'package:emporos/config/globals.dart';
import 'package:emporos/pages/add_item.dart';
import 'package:emporos/pages/shop_items_page.dart';
import 'package:flutter/material.dart';
import 'item_reviews_page.dart';
import 'package:shared_preferences/shared_preferences.dart';




class OrdersPage extends StatefulWidget {
  @override
  _ShopItemsPageState createState() => _ShopItemsPageState();


}
// late List<Map<String, dynamic>> products;
// initialize data

Future respond(String url,String orderId, String variation, String productName, String username)async{
  final sharedpref = await SharedPreferences.getInstance();
  final vendorName = await sharedpref.getString('businessName');
  final response = await Request(body: {'vendorName':vendorName,'username':username, 'orderId':orderId, 'productName':productName,
    'variation':variation}, path: Uri.parse(Globals.orderApprovalUrl)).sendData();
  if(response.statusCode==200){
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['code']==200){
    //  animate something

    }
  }

  
}

Future loadData(String url,{Map<String,String> body = const {'chenni':'chenni'}}) async {


  final response = await Request(body: body, path: Uri.parse(url)).fetchData();
  if(response.statusCode==200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    if(data['code']==200){


      List<dynamic> products =  data['response'];
      //loop through and return only those that are pending
      List<dynamic> pendingOrders=[];
      for (Map<String, String> product  in products){
        if(product['status']==0){
          pendingOrders.add(product);
        }
      }



      return pendingOrders;

    }
  }
}

class _ShopItemsPageState extends State<OrdersPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  FutureBuilder(

                      future:loadData(Globals.ordersUrl), builder: (context, snapshot){
                    if(snapshot.hasData){
                      print(snapshot.data);
                      if(((snapshot.data) as List).length==0){
                        return Text("You have no orders");
                      }
                      print("Wise "+snapshot.data[0].toString());

                      return ListView.builder(physics: ClampingScrollPhysics(),shrinkWrap: true,itemBuilder: (context,index){
                        return NewShopItem(product: snapshot.data[index],);
                      },
                          itemCount: snapshot.data.length);
                    }else if(snapshot.hasError){
                      //TODO:: change this to a better widget
                      //email stacktracdec and device info to developer

                      print(snapshot.stackTrace);
                      return Text("An Error Occurred");

                    }else{
                      return CircularProgressIndicator();
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class ResponseButton extends StatefulWidget {

  final String activeOrderId;
  final String activeProductName;
  final String activeVariation;
  final String activeUsername;
  final Widget parent;


  ResponseButton({required this.activeOrderId, required this.activeProductName, required this.activeVariation, required this.activeUsername, required this.parent});

  @override
  _ResponseButtonState createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<ResponseButton> {
  String _selectedItem = 'Respond';


  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: ['Respond', 'Accept', 'Reject'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded:true,
      value: _selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue!;

        //  send network request to respond order but first show confirmation dialogue
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Warning'),
                content: Text('Are you sure you want to '+ _selectedItem.toLowerCase()+' this order?'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                    //  send network request to respond to order

                      String url='';
                      if(_selectedItem=='Respond'){
                        return null;
                      }
                      if (_selectedItem=='Approve'){
                        url=Globals.orderApprovalUrl;
                      }else{
                        url=Globals.orderRejectionUrl;
                      }

                      //during response....disable click of response button and animate loading
                      (widget.parent as NewShopItem).opacity=0.5;
                      respond(url,widget.activeOrderId, widget.activeVariation, widget.activeProductName,widget.activeUsername);


                    },
                  ),
                ],
              );
            },
          );


        });
      },

    );
  }
}

class _NewShopItemState extends State<NewShopItem>{

  @override
  Widget build(BuildContext context)
  {
    return Opacity(
      opacity: widget.opacity,
      child: Padding

        (
        padding: EdgeInsets.only(bottom: 16.0),
        child: Align
          (
          alignment: Alignment.topCenter,
          child: SizedBox.fromSize
            (
              size: Size.fromHeight(250.0),
              child: Stack
                (
                fit: StackFit.expand,
                children: <Widget>
                [
                  /// Item description inside a material
                  Container
                    (
                    margin: EdgeInsets.only(top: 24.0),
                    child: Material
                      (
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      color: Colors.white,
                      child: Padding
                        (
                        padding: EdgeInsets.all(24.0),
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            /// Title and rating
                            Column
                              (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>
                              [
                                Text(widget.product['productName'], style: TextStyle(color: Colors.blueAccent)),
                                Row
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Text('No reviews', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),

                                  ],
                                ),
                              ],
                            ),
                            /// Infos
                            ///
                            ResponseButton(activeVariation: widget.variations,activeProductName: widget.product['productName'],
                              activeOrderId: widget.product['orderId'].toString(),activeUsername: widget.product['username'],parent: widget,),
                            Row
                              (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>
                              [
                                Text('Bought', style: TextStyle()),
                                Padding
                                  (
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text('0', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                                Text('times for a profit of', style: TextStyle()),
                                Padding
                                  (
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Material
                                    (
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.green,
                                    child: Padding
                                      (
                                      padding: EdgeInsets.all(4.0),
                                      child: Text('\$ 0', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              //variations
                              children: [
                                FutureBuilder(builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    //  loop through variations and add text widgets
                                    //  This part is a bad idea but hopefully i can afford developers to fix it soon.... wait...i can get around it
                                    List<dynamic> data = snapshot.data as List<dynamic>;
                                    List<Widget> rowKids=[];

                                    if(snapshot.data.isEmpty){
                                      return Text("No Variations");
                                    }
                                    for (int i = 0;i <data.length;i++) {
                                      // select only if variation ID matches the order
                                      if (data[i]['variationId']==widget.product['variationId']) {
                                        if (i == data.length - 1) {
                                          widget.variations = widget.variations +
                                              data[i]['variantName'] + ": " +
                                              data[i]['value'];
                                        } else {
                                          widget.variations = widget.variations +
                                              data[i]['variantName'] + ": " +
                                              data[i]['value'] + ", ";
                                        }
                                      }
                                    }
                                    rowKids.add(Flexible(child: Text(widget.variations,maxLines: 3,)));
                                    return Row(children: rowKids,);

                                  }else if(snapshot.hasError){
                                    return Text("failed to get variations");
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },future: loadData(Globals.variationsUrl+"?productId="+widget.product['productId'],),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  /// Item image
                  Align
                    (
                    alignment: Alignment.topRight,
                    child: Padding
                      (
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox.fromSize
                        (
                        size: Size.fromRadius(54.0),
                        child: Material
                          (
                          elevation: 20.0,
                          shadowColor: Color(0x802196F3),
                          shape: CircleBorder(),
                          child: ClipRRect(

                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              fit: BoxFit.cover,
                              image:
                              NetworkImage(Globals.picturesUrl+"?productId="+widget.product['productId']),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}

class NewShopItem extends StatefulWidget
{
  final Map<String, dynamic> product;

  String orderTotal="";
  bool delivery=false;
  String variations = "";
  double opacity=1.0;
  NewShopItem({required this.product});
  @override
  _NewShopItemState createState() => _NewShopItemState();




}