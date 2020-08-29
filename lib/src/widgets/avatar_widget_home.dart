import 'package:flutter/material.dart';

class AvatarWidgetHome extends StatelessWidget {
  final String image;

  const AvatarWidgetHome({@required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'container_$image',
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 33,
              height: 33,
              child: Hero(
                tag: 'avatar_$image',
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    this.image,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

/*  return Hero(
    tag: 'container_$image',
    child: Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30)
      ),
      padding: const EdgeInsets.all(3),
      child: CircleAvatar(
        backgroundImage: AssetImage(
          this.image,
        ),
        radius: 15,
      ),
    ),
  );*/
  }
}
