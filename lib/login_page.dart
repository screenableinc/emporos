// import 'dart:html';

import 'package:emporos/mainscreen.dart';
import 'package:emporos/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up.dart';
import 'package:http/http.dart' as http;
import 'config/globals.dart';
import 'dart:convert';
import 'apiaccess/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super (key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}
  class _LoginPageState extends State<LoginPage>{

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    @override
    Widget build(BuildContext context){

      Future signIn() async{
      //  do something to show loading
      //  get Request
        final email = emailController.text;
        final password = passwordController.text;

        final response =    await new Request(body: {'businessId':email,'password':password}, path: Uri.parse(Globals.loginUrl)).sendData();

        if (response.statusCode==200){
        //  store token and other pertinent info as wll as timestamp

          Map<String, dynamic> data = jsonDecode(response.body);

          if(data['code']==100){
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accesstoken', data['token']);
          await prefs.setString('businessId', email);
          await prefs.setString('password', password);
          await prefs.setString('businessName', data['response']['businessName']);
          await prefs.setBool('loggedIn', true);
        //  success send to main page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );


        }else if(data['code']==403){
            // auth error
          //  do some UI magic
          }
      }
        return response;

      

      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
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
                  Text("Welcome back, you\'ve been missed!",
                  style: TextStyle(fontSize: 18),),
                  SizedBox(height: 12,),
                  //Vendor Id
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
                          controller: emailController,
                          decoration: InputDecoration(

                          border: InputBorder.none, hintText: "Enter Vendor Id or E-mail"
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
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Password"
                        ),),
                      ),
                    ),
                  ),
                SizedBox(height: 20,),
                //  Button
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: signIn,
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
                      ),

                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a vendor? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SigninPage()),
                          );
                        },
                        child: Text("Register now", style: TextStyle(color: Colors.pink, fontWeight:
                        FontWeight.bold),),
                      )
                    ],
                  )

                  
                ]),
          ),
      ),
      );
    }
}

