import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wanderapp/src/models/trip.dart';
import 'package:wanderapp/src/widgets/avatar_widget_home.dart';

class TripWidget extends StatelessWidget {
  final bool main;
  final Trip trip;
  final VoidCallback onTap;

  const TripWidget({
    this.main = false,
    @required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMMM d-yy');
    double _left = -5;

    return InkWell(
      onTap: onTap,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Hero(
            tag: 'image_${trip.image}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: main
                  ? AspectRatio(
                      aspectRatio: 21 / 19,
                      child: Image.asset(
                        trip.image,
                        fit: BoxFit.cover,
                        height: 40,
                      ),
                    )
                  : Image.asset(
                      trip.image,
                      fit: BoxFit.cover,
                      width: 200,
                    ),
            ),
          ),
          Positioned(
            bottom: main ? 40 : 20,
            left: 20,
            child: SizedBox(
              width: main ? 200 : 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'date_${trip.date}',
                    child: Text(
                      '${format.format(trip.date).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(height: main ? 15 : 10),
                  Hero(
                    tag: 'title_${trip.title}',
                    child: Text(
                      trip.title,
                      style: TextStyle(
                        fontSize: main ? 20 : 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        height: 1.4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (main)
            ...trip.avatar.map((avatar) {
              _left += 30;

              return Positioned(
                bottom: -20,
                left: _left,
                child: AvatarWidgetHome(
                  image: avatar.image,
                ),
              );
            }).toList()
        ],
      ),
    );
  }
}
