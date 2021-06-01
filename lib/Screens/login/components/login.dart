import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_login/Screens/footer/AldreadyAcc.dart';
import 'package:mysql_login/Screens/login/components/backgrounds.dart';
import 'package:mysql_login/Screens/signup/signupScreen.dart';
import 'package:mysql_login/constant.dart';
import 'package:mysql_login/main/mainPage.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHidden = true;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                "LOGIN",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 60, right: 60),
                  height: size.height * 0.055,
                  child: email()),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 60, right: 60),
                  height: size.height * 0.055,
                  child: password()),
              SizedBox(
                height: size.height * 0.03,
              ),
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
                    child: processing == false?  Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ) : CircularProgressIndicator(backgroundColor: kPrimaryLightColor, valueColor: AlwaysStoppedAnimation(kPrimaryColor)) ,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        loginButton();
                      }
                    }),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              AlreadyAccount(
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
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

  tooglepasswordView() {
    setState(() {
      // ignore: unnecessary_statements
      _isHidden != _isHidden;
    });
  }

  loginButton() async {
    setState(() {
      processing = true;
    });
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => MainPage()));

    var url = Uri.parse("http://192.168.234.1/flutter_crud/flutter_login/sign_in.php");
    var data = {
      "email": _emailController.text,
      "pass": _passwordController.text
    };

    var res= await http.post(url, body:data);

    if(jsonDecode(res.body) == "don't have account"){
      Fluttertoast.showToast(msg: "don't have an account, Create an account", toastLength: Toast.LENGTH_SHORT);

    }
    else{
      if(jsonDecode(res.body) == "false"){
        Fluttertoast.showToast(msg: "incorrect password", toastLength: Toast.LENGTH_SHORT);
      }
      else{
        print(jsonDecode(res.body));
        Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }

    // setState(() {
    //   processing = false;
    // });
  
  }
}
