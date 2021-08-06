import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget buttonIcon;
  final VoidCallback onPressed;


  const SocialLoginButton(
      {
        this.buttonText,
        this.buttonColor,
        this.textColor : Colors.white,
        this.radius : 16,
        this.yukseklik : 40,
        this.buttonIcon,
        this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        child: ElevatedButton(onPressed: onPressed,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children : [
                if (buttonIcon != null) ... [
                  buttonIcon,
                  Text(
                    buttonText
                    ,style: TextStyle(color: textColor),),
                  Opacity(
                      opacity: 0,
                      child: buttonIcon)
                ],
                if (buttonIcon == null) ... [
                  Container(),
                  Text(
                    buttonText
                    ,style: TextStyle(color: textColor),),
                  Container()
                ]




              ]
          ),style: ElevatedButton.styleFrom(
              primary: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              )
          ),),
      ),
    );
  }
}
