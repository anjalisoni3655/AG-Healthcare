import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String image;
  const CustomButton({@required this.title, @required this.onPressed, this.image})
      : assert(title != null),
        assert(onPressed != null),
        assert(image != null);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.blue,
          width: 2.5,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal:17),
      elevation: 0.0,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 30),
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.85),
            backgroundImage: AssetImage(image),
            radius: 40,
          ),
        ],
      ),
    );
  }
}