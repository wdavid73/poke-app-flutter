import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconContainer extends StatelessWidget {
  final double size;
  final String iconUrl;
  final Color color;
  final bool shadow;

  const IconContainer({
    Key key,
    @required this.size,
    @required this.iconUrl,
    this.color = Colors.white,
    this.shadow = true,
  })  : assert(size > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(this.size * 0.15),
        boxShadow: this.shadow
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 15),
                )
              ]
            : [],
      ),
      padding: EdgeInsets.all(this.size * 0.15),
      child: Center(
        child: SvgPicture.asset(this.iconUrl),
      ),
    );
  }
}
