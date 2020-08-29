import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.menu,
          color: Colors.black,
        ),
        CircleAvatar(
          backgroundImage: AssetImage('assets/avatar_10.jpg'),
          radius: 22,
        )
      ],
    );
  }
}
