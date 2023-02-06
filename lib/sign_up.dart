import 'package:emporos/config/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'apiaccess/requests.dart';
import 'package:url_launcher/url_launcher.dart';
class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super (key: key);


  @override
  State<SigninPage> createState() => _SigninPageState();
}
class _SigninPageState extends State<SigninPage>{
  @override
  Widget build(BuildContext context){
    var emailController = TextEditingController();
    var vendorNameController = TextEditingController();
    var passwordController = TextEditingController();
    Future signUp() async{
      //  get Request
      var email = emailController.text;
      var vendor = vendorNameController.text;
      var password = passwordController.text;

      //create businessId use email for now
      //mask password
      var requestBody = {'businessName': vendor, 'businessId':email, 'password': password};
      // var res = new Request(body: requestBody, path: '/business/login', method: "GET").fetchData();
      
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset('lib/assets/images/insta.png',
                    height: 100, width: 100,),
                  SizedBox(height: 40,),
                  Text("Hello Vendor!",style: GoogleFonts.bebasNeue(
                      fontSize: 40
                  ),),
                  SizedBox(height: 10,),
                  Text("Welcome!",
                    style: TextStyle(fontSize: 18),),
                  SizedBox(height: 12,),
                  //Vendor Id or Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(color:
                      Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Email Address"
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(color:
                      Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Vendor Name"
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  //  Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(color:
                      Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Password"
                          ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'By clicking the checkbox, you agree to our'),

                              TextSpan(text: ' terms of service',
                                  style: TextStyle(
                                      color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                              ..onTap =() {
                              launchUrl(Uri.parse(Globals.tosUrl+"?party=vendor"));}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                  //  Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.pink,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('Sign In',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),)),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a vendor? "),


                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("Sign in", style: TextStyle(color: Colors.pink, fontWeight:
                        FontWeight.bold),),
                      )
                    ],
                  )


                ]),
          ),
        ),
      ),
    );
  }
}
