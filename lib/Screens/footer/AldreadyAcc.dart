import 'package:flutter/material.dart';
import 'package:mysql_login/constant.dart';

class AlreadyAccount extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyAccount({Key key,
    this.login = true,
    this.press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Text(login? "Don't have account ?" : "ALready have an account ?"),
        GestureDetector(
          onTap: press,
          child: Text( login? "Sign Up" : "Sign In",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold
          ),
        ),
        )
      ],
    );
  }
}