import 'dart:convert';
// import 'dart:html';

import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:path/path.dart' as path;

import 'package:emporos/apiaccess/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emporos/config/globals.dart';
import 'package:emporos/pages/add_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
//variations schema
Map<String, dynamic> variationJson = {"variations": [],"attr_count":0,"attrs":[]};
Stream<List<dynamic>> _dataStream = Stream.value(variationJson['attrs']);
TextEditingController controller = TextEditingController();
class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}
String _category="";

Future wise() async{
// print("called1 ");

final response = await Request(body: {}, path: Uri.parse(Globals.categoriesUrl)).fetchData();
if(response.statusCode==200) {
Map<String, dynamic> data = await jsonDecode(response.body);

if(data['code']==200){

List categories =  data['response'];



return categories;


}
}
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  List<PickedFile> _images = [];
  bool deliverable=false;
  bool _isFetched = false;
  bool _isBuilt =false;

  @override
  Widget build(BuildContext context) {
    String _productName = "";
    double _price = 0.00;
    String _description= "";
    String _barcode="";



    DateTime _timestamp = DateTime.now();
    String _tag="";

    return Scaffold(



      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              // var _formKey = GlobalKey<FormState>();


              key: _formKey,
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(


                  child: Column(


                    children: [
                      // Other form fields...


                      ElevatedButton(
                        onPressed: () async {
                          if (_images.length < 4) {
                            // List<File> images = await ImagePicker.pickImages(source: ImageSource.gallery);
                            XFile image = await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;

                            setState(() {
                              _images.add(PickedFile(image.path));
                            });
                          }
                        },
                        child: Text('Select images from gallery'),
                      ),


                      // Display the selected images
                      Row(
                        // decoration: BoxDecoration(color:
                        // Colors.grey[200],
            //     border: Border.all(
                        //       color: Colors.white,
                        //     ),
                        //     borderRadius: BorderRadius.circular(12)),

                        children: _images.map((image) => Container(
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                          )
                           ,
                          child: Image.file(
                            File(image.path),



                            width: 70,

                            height: 70,
                            fit: BoxFit.cover,


                          ),
                        )).toList(),
                      ),
                      // Other buttons or form fields...

              Row(
                  children: [
                    Expanded(child: TextFormField(
                      decoration: InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                      onSaved: (value) => _productName = value as String,
                    )),
                  ],
              ),
              Row(
                  children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(

                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                          onSaved: (value) => _price = double.parse(value as String),

                        ),
                      ),
                    ),


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(future:wise()
                        ,builder: (context, snapshot){


                          if (snapshot.hasData){




                            return CategoriesButton(categories: snapshot.data as List<dynamic>);
                          }else if(snapshot.hasError){
                            print(snapshot.error);
                            return CircularProgressIndicator();
                          }else{


                          //   if no list is returned due to error...automatically ask user to hit refresh or make it generic
                            return CircularProgressIndicator();
                          }
                        },),
                      ),
                    ),
                  ],
              ),


                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Barcode'),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => _barcode = value as String,
                              ),
                            ),
                          ),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Tag'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a tag';
                                }
                                return null;
                              },

                              onSaved: (value) => _tag = value as String,
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: StreamBuilder<List<dynamic>>(
                            stream: _dataStream,
                            builder: (context, snapshot) {


                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Container(child: GestureDetector(child: Text(textAlign: TextAlign.center,"Tap here to add attributes to your product listing such as color, size, etc. ")
                                  ,onTap: (){
                                  //show dialogue box where user can type attribute to add#

                                     showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Add Attribute'),
                                              content: TextField(controller: controller,autofillHints: ["Size, Color, Inches"],decoration: InputDecoration(hintText: "Please enter an attribute"),),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text('add'),
                                                  onPressed: () {
                                                  //  add to table

                                                    if(controller.text !=''){
                                                    setState(() {
                                                        //create new columns while keeping data in existing ones same
                                                        //when a new attribute is added, loop through all variations(rows) and add an edit text to the last item
                                                      // :[{"wise":"okay"},{"wise":"tt"},{"wise":"tt"},{"wise":"tt"}],"attr_count":0,"attrs":["wise","colu2"]};




                                                        List<Map<dynamic, dynamic>> variations;
                                                        bool should_add_qty=false;
                                                        // create initial map (row) but first check if exists
                                                        if((variationJson["attrs"] as List).length>0){
                                                          variations = variationJson["variations"];
                                                        //  add key value pair
                                                        //honestly think the code doesnt need this but fuck it, i'm tired
                                                          variations[0][controller.text]="";

                                                        } else {
                                                          should_add_qty=true;

                                                          (variationJson["attrs"] as List)
                                                              .add(
                                                              "Qty");
                                                          variations=[{"Qty":"",controller.text: ""}];
                                                          variationJson["variations"] = variations;


                                                        }
                                                        (variationJson["attrs"] as List)
                                                            .add(
                                                            controller.text);




                                                        _dataStream=Stream.value(variationJson["attrs"]);
                                                        controller.text="";


                                                    });
                                                    };






                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );


                                  },)
                                  ,);
                              }



                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      if((variationJson["attrs"] as List).isNotEmpty) GestureDetector(onTap:(){

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Add Attribute'),
                                              content: TextField(controller: controller,autofillHints: ["Size, Color, Inches"],decoration: InputDecoration(hintText: "Please enter an attribute"),),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text('add'),
                                                  onPressed: () async{
                                                    //  add to table
                                                    // [["Wise","kj"]],"attr_count":0,"attrs":["Wise","col2"]};

                                                    if(controller.text !=''){

                                                      setState(() {
                                                        //create new columns while keeping data in existing ones same
                                                        //when a new attribute is added, loop through all variations(rows) and add an edit text to the last item
                                                        // :[{"wise":"okay"},{"wise":"tt"},{"wise":"tt"},{"wise":"tt"}],"attr_count":0,"attrs":["wise","colu2"]};

                                                        (variationJson["attrs"] as List)
                                                            .add(
                                                            controller.text);
                                                        List<Map<dynamic, dynamic>> variations = (variationJson["variations"]) as List<Map<dynamic, dynamic>>;
                                                        // create initial map (row) but first check if exists
                                                        if(variations.isNotEmpty){
                                                          //  add key value pair
                                                          for (int i = 0; i < variations.length; i++) {
                                                            variations[i][controller.text]="";

                                                          }

                                                          variations[0][controller.text]="";
                                                          variationJson["variations"] = variations;

                                                        } else {
                                                          variations.add({controller.text: ""});
                                                          variationJson["variations"] = variations;

                                                        }


                                                        _dataStream=Stream.value(variationJson["attrs"]);
                                                        controller.text="";



                                                      });
                                                    };






                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } , child: Icon(Icons.add_box_outlined,semanticLabel: "Attribute",)),
                                      DataTable(


                                        columns: ((variationJson["attrs"]) as List).map((name) => DataColumn(label: Text(name))).toList(),
                                        rows: ((variationJson["variations"]) as List<Map>).mapIndexed((int index, row) => DataRow(
                                          cells: row.keys.mapIndexed((int count, entry) => DataCell(TextFormField(onChanged: (text){
                                            // (row[entry] = text.toString());

                                            //index and count are the positions of the row and column respectively
                                            print(variationJson);
                                            updateJson(index, count,text);

                                            print(index.toString()+"____"+ count.toString()+row.toString());


                                            },
                                          decoration: InputDecoration(hintText: "Enter ${row[entry].toString()}"),
                                          )
                                          )).toList(),
                                        )).toList(),
                                      ),
                                      if((variationJson["attrs"] as List).isNotEmpty) GestureDetector(onTap: (){
                                      //  get the ffirst variation and create a row just like it
                                        var newMap = {};
                                        for (int i = 0; i < variationJson["variations"][0].keys.length; i++) {
                                          newMap[variationJson["variations"][0].keys.elementAt(i)]="";
                                        }
                                        print(newMap);


                                        ((variationJson["variations"]) as List<Map<dynamic, dynamic>>).add(newMap);
                                        setState(() {
                                          _dataStream=Stream.value(variationJson["attrs"]);
                                        });
                                      }, child: Icon(Icons.add_box_outlined,color: Colors.blue,)),
                                    ],
                                  ),
                                ),
                              );

                            },
                          ),
                        ),
                      )
                      ,

              TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {

                    _description = value as String;
                  },
              ),
                      Column(
                        children: [
                          TextField(

                            onChanged: (String value){
                              if(value.endsWith(";")){
                              //  add row with with attribute name

                              }
                            },
                          )
                        ],
                      )
                      ,

                      Center(
                        child: Row(
                          children: [
                            Text("Deliverable: "),

                             Switch(
                                value: deliverable,
                                onChanged: (bool newValue) {
                                  setState(() {

                                    deliverable = newValue;
                                  });
                                },
                              ),


                          ],
                        ),
                      ),



              ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async{



                    if (_formKey.currentState!.validate()) {
                      // Save the product to your database or do something else with the information
                      _formKey.currentState?.save();


                      var request = http.MultipartRequest("POST", Uri.parse(Globals.addItemUrl));
                      //generate randomID...check webversion to see criteria
                      if (deliverable==true){
                        request.fields["deliverable"]="1";
                      }else{
                        request.fields["deliverable"]="0";
                      }


                      request.fields["price"]=_price.toString();
                      request.fields["category"]=_category;
                      //todo::fix this cause barcode can be null
                      request.fields["barcode"]=_barcode;
                      request.fields["productName"]=_productName;
                      request.fields["quantity"]="1";request.fields["description"]=_description;
                      //pass timestampt to be used as part of file name
                      //also pass image count
                      request.fields["imageCount"]=_images.length.toString();
                      request.fields["identifier"]=DateTime.now().toString();
                      request.fields["tag"]=_tag;
                      variationJson["attr_count"]=(variationJson["variations"]).length;
                      request.fields["attrs"]=jsonEncode(variationJson);

                      final prefs = await SharedPreferences.getInstance();
                      final token  = await prefs.getString('accesstoken').toString();
                      final businessId  = await prefs.getString('businessId').toString();
                      var randToken = await genRandToken(11);
                      var filename = randToken+"_"+businessId;
                      request.fields["productId"]=randToken;
                      request.headers["businessId"]=businessId;
                      for(var i = 0; i < _images.length; i++) {

                        var fileBytes = await _images[i].readAsBytes();
                        var extension = path.extension(_images[i].path);
                        var multipartFile = http.MultipartFile.fromBytes(
                            'file', fileBytes, filename: i.toString()+filename+extension);

                        request.files.add(multipartFile);
                  }



                      request.headers["user-agent"]="mobile";
                      request.headers["token"]=token;

                      // ={"user-agent":"mobile", "token": token};

                     http.StreamedResponse response = await request.send();

                     var responsebody = await response.stream.bytesToString();
                     print(responsebody);


                      // print(formData.get('file0'));
                    }
                  },
              )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void updateJson(int rowPosition, int columnPosition, String text) {
  (variationJson["variations"] as List<Map>)[rowPosition][(variationJson["variations"] as List<Map>)[rowPosition].keys.elementAt(columnPosition)]=text;
  print(variationJson);
}



String genRandToken(int range) {
  var text = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";

  for (var i = 0; i < range; i++) {
    text += possible[Random().nextInt(possible.length)];
  }
  return text;
}

class CategoriesButton extends StatefulWidget {

  late List<dynamic> categories;


  CategoriesButton({required this.categories});


  @override
  _ResponseButtonState createState() => _ResponseButtonState();

}

class _ResponseButtonState extends State<CategoriesButton> {
  late String _selectedItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedItem= widget.categories[0]['categoryId'].toString();
    _category=_selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: widget.categories.map((dynamic key_value_pair) {
        return DropdownMenuItem<String>(
          value: key_value_pair['categoryId'].toString(),
          child: Text(key_value_pair['name']),
        );
      }).toList(),
      isExpanded:true,
      value: _selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue!;
          _category = _selectedItem;







        });
      },

    );
  }
}

