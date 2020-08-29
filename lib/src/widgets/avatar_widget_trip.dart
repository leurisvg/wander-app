import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wanderapp/src/models/trip.dart';

class AvatarWidgetTrip extends StatelessWidget {
  final Avatar avatar;

  AvatarWidgetTrip({@required this.avatar});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> _opacity = ValueNotifier(false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _opacity.value = true;
    });

    return WillPopScope(
      onWillPop: () async {
        _opacity.value = false;
        return true;
      },
      child: Expanded(
        flex: 5,
        child: Container(
          height: 40,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Hero(
                    tag: 'container_${avatar.image}',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                        width: 33,
                        height: 33,
                        child: Hero(
                          tag: 'avatar_${avatar.image}',
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              this.avatar.image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: _opacity,
                    builder: (BuildContext context, value, Widget child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 1500),
                        opacity: _opacity.value ? 1.0 : 0.0,
                        child: child,
                      );
                    },
                    child: Hero(
                      tag: 'name_${this.avatar.name}',
                      child: Text(
                        this.avatar.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 2)
                ],
              )
            ],
          ),
        ),
      ),
    );

/*
    return Expanded(
      flex: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Hero(
            tag: 'container_${avatar.image}',
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey[800].withOpacity(0.5),
                borderRadius: BorderRadius.circular(30)
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      this.avatar.image,
                    ),
                    radius: 15,
                  ),
                  const SizedBox(width: 10),
                  ValueListenableBuilder(
                    valueListenable: _opacity,
                    builder: (BuildContext context, value, Widget child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 1500),
                        opacity: _opacity.value ? 1.0 : 0.0,
                        child: child,
                      );
                    },
                    child: Text(
                      this.avatar.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    ),
                  ),
                  Spacer(flex: 2)
                ],
              ),
            ),
          ),
        ),
      ),
    );
*/
  }
}
