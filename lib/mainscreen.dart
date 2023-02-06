import 'package:emporos/mainscreen.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget{
  const MainScreen({Key? key}) : super (key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();

}
class _MainScreenState extends State<MainScreen>{
  @override
  Widget build(BuildContext context){
    var accentColor = Colors.pink;
    return Scaffold(
      appBar: AppBar(title: Text("Here We go!!"),),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [

                Container(

                  decoration: BoxDecoration(

                  ),
                  child: Card(
                    elevation: 3,
                      child:Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(width: 1.0,
                              color: Colors.pink)),
                              child: Icon(Icons.analytics_outlined,size: 80,color: Colors.pink,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Analytics"),
                            )
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(),
          children: [
            //replace drawer header with picture of vendor and name..also include cover pic
            const DrawerHeader(child: Text("Actions")),
            ListTile(
              title: Row(children: [
                Icon(Icons.dashboard),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Dashboard"),
                )
              ],),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(children: [
                Icon(Icons.add_box_outlined),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Add New Product"),
                )
              ],),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(children: [
                Icon(Icons.notifications),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Notifications"),
                )
              ],),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(children: [
                Icon(Icons.settings),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Settings"),
                )
              ],),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}