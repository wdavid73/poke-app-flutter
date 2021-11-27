import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/utils/responsive.dart';

class ButtonTap extends StatelessWidget {
  final String text;
  final IconData icon;
  final GestureTapCallback onPressed;
  final Color iconColor, fillColor, textColor;
  final bool textBold, withShadow, isLoading;
  final double width;

  ButtonTap({
    Key key,
    @required this.text,
    @required this.onPressed,
    @required this.width,
    this.icon,
    this.iconColor,
    this.textBold = false,
    this.withShadow = false,
    this.fillColor,
    this.textColor = Colors.white,
    this.isLoading,
  })  : assert(text != null),
        // assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: this.width,
        decoration: this.withShadow
            ? BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: Colors.pinkAccent,
                  )
                ],
              )
            : null,
        child: RawMaterialButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
            child: !this.isLoading
                ? Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${this.text}',
                            maxLines: 1,
                            style: TextStyle(
                              color: this.textColor,
                              fontSize: responsive.dp(2),
                              fontWeight:
                                  this.textBold ? FontWeight.bold : null,
                            ),
                          )
                        ],
                      ),
                      this.icon != null
                          ? Icon(
                              this.icon,
                              color: this.iconColor != null
                                  ? this.iconColor
                                  : Colors.white,
                              size: responsive.dp(2.8),
                            )
                          : Container(),
                    ],
                  )
                : Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
          ),
          fillColor: this.fillColor != null ? this.fillColor : Colors.redAccent,
          splashColor: Colors.red,
          onPressed: this.isLoading ? null : this.onPressed,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
