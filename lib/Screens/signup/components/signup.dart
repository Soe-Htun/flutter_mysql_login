import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_login/Screens/footer/AldreadyAcc.dart';
import 'package:mysql_login/Screens/login/components/backgrounds.dart';
import 'package:mysql_login/Screens/login/loginScreen.dart';
import 'package:mysql_login/constant.dart';
// import 'package:mysql_login/main/mainPage.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isHidden = true;
  // bool _isConfirmHidden = true;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // TextEditingController _confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Backgrounds(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    decoration: TextDecoration.none),
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.3,
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              //email address
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 60, right: 60),
                  height: size.height * 0.055,
                  child: email()),

              SizedBox(
                height: size.height * 0.02,
              ),

              //name
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 60, right: 60),
                  height: size.height * 0.055,
                  child: name()),

              SizedBox(
                height: size.height * 0.02,
              ),

              //password
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 60, right: 60),
                  height: size.height * 0.055,
                  child: password()),

              SizedBox(
                height: size.height * 0.03,
              ),

              // Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.only(left: 60, right: 60),
              //     height: size.height * 0.055,
              //     child: Confirmpassword()),

              SizedBox(
                height: size.height * 0.03,
              ),

              //Sign Up
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 60, right: 60),
                height: size.height * 0.055,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(color: kPrimaryColor)))),
                    child: processing == false
                        ? Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: kPrimaryLightColor,
                            valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                          ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        signUpAction();
                      }
                    }),
              ),

              SizedBox(
                height: size.height * 0.04,
              ),

              AlreadyAccount(
                login: false,
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget email() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: kPrimaryLightColor),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.people,
              color: kPrimaryColor,
            ),
            hintText: "Your email",
            // fillColor: kPrimaryLightColor,
            // filled: true,

            border: InputBorder.none
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(18),
            // )
            ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'email is required';
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "Please enter a valid email address";
          }
          return null;
        },
        // onSaved: (String value) {
        //   _email = value;
        // },
      ),
    );
  }

  Widget name() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: kPrimaryLightColor),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.people,
              color: kPrimaryColor,
            ),
            hintText: "Your name",
            // fillColor: kPrimaryLightColor,
            // filled: true,

            border: InputBorder.none
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(18),
            // )
            ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'name is required';
          }

          return null;
        },
        // onSaved: (String value) {
        //   _email = value;
        // },
      ),
    );
  }

  Widget password() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: kPrimaryLightColor),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _isHidden,
        // keyboardType: TextInputType.visiblepassword,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintText: "Your password",
            // fillColor: kPrimaryLightColor,
            // filled: true,
            suffixIcon: InkWell(
              child: Icon(
                _isHidden ? Icons.visibility : Icons.visibility_off,
                color: kPrimaryColor,
              ),
              onTap: tooglepasswordView,
            ),
            border: InputBorder.none
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(18),
            // )
            ),

        validator: (String value) {
          if (value.isEmpty) {
            return 'password is required';
          }
          return null;
        },
        // onSaved: (String value){
        //   _password = value;
        // },
      ),
    );
  }

  // Widget Confirmpassword() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(18), color: kPrimaryLightColor),
  //     child: TextFormField(
  //       controller: _confirmpasswordController,
  //       obscureText: _isConfirmHidden,
  //       // keyboardType: TextInputType.visiblepassword,
  //       decoration: InputDecoration(
  //           prefixIcon: Icon(
  //             Icons.lock,
  //             color: kPrimaryColor,
  //           ),
  //           hintText: "Confirm password",
  //           // fillColor: kPrimaryLightColor,
  //           // filled: true,
  //           suffixIcon: InkWell(
  //             child: Icon(
  //               _isConfirmHidden ? Icons.visibility : Icons.visibility_off,
  //               color: kPrimaryColor,
  //             ),
  //             onTap: toogleConfirmpasswordView,
  //           ),
  //           border: InputBorder.none
  //           // border: OutlineInputBorder(
  //           //   borderRadius: BorderRadius.circular(18),
  //           // )
  //           ),

  //       validator: (String value) {
  //         if (value.isEmpty) {
  //           return 'password is required';
  //         }
  //         else if(_passwordController != _confirmpasswordController){
  //           return 'password must be the same';
  //         }
  //         return null;
  //       },
  //       // onSaved: (String value){
  //       //   _password = value;
  //       // },
  //     ),
  //   );
  // }

  void tooglepasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  // void toogleConfirmpasswordView(){
  //   setState(() {
  //     _isConfirmHidden = ! _isConfirmHidden;
  //   });
  // }

  void signUpAction() async {
    setState(() {
      processing = true;
    });

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => MainPage()));

    var url = Uri.parse("http://192.168.234.1/flutter_crud/flutter_login/signup.php");
    var data = {
      "email": _emailController.text,
      "name": _nameController.text,
      "pass": _passwordController.text
    };

    var res = await http.post(url, body:data);

    if (jsonDecode(res.body) == "account already exists"){
      Fluttertoast.showToast(
          msg: "account exists , Please Login",
          toastLength: Toast.LENGTH_SHORT);
    } else {
      if (jsonDecode(res.body) == "true") {
        Fluttertoast.showToast(
            msg: "account created", toastLength: Toast.LENGTH_SHORT);
            print(res.body);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Fluttertoast.showToast(msg: "error", toastLength: Toast.LENGTH_SHORT);
      }
    }
    setState(() {
      processing = false;
    });
  }
}

// class Fluttertoast {
//   static void showToast({String msg, Toast toastLength}) {}
// }
