import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:wanderapp/src/models/trip.dart';
import 'package:wanderapp/src/pages/trip_details_page.dart';

class TripPage extends StatelessWidget {
  final Trip trip;

  const TripPage({this.trip});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMMM d-yy');
    ValueNotifier<bool> _startAnimation = ValueNotifier(false);
    bool result = false;

    _onVerticalUpdate(DragUpdateDetails details) async {
      if (details.primaryDelta < -7) {

        _startAnimation.value = true;

        result = await Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (BuildContext context, animation, animation1) {
            return FadeTransition(
              opacity: animation,
              child: TripDetailsPage(trip: trip),
            );
          },
        ));
      }

      if (result == true) _startAnimation.value = false;

      if (details.primaryDelta > 7) {
        Navigator.pop(context, true);
      }
    }

    return Material(
      child: GestureDetector(
        onVerticalDragUpdate: _onVerticalUpdate,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: _startAnimation,
              builder: (BuildContext context, bool value, Widget child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  top: value ? -50 : 0,
                  bottom: value ? 0 : -50,
                  left: 0,
                  right: 0,
                  child: child,
                );
              },
              child: Hero(
                tag: 'image_${trip.image}',
                child: Image.asset(
                  trip.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _startAnimation,
              builder: (BuildContext context, value, Widget child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  bottom: value ? 400 : 140,
                  left: 40,
                  child: child,
                );
              },
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'date_${trip.date}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          '${format.format(trip.date).toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Hero(
                      tag: 'title_${trip.title}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          trip.title,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: <Widget>[
                    _AvatarWidget(
                      avatar: trip.avatar.first,
                    ),
                    const Spacer(),
                    _AvatarWidget(
                      avatar: trip.avatar[1],
                    ),
                    const Spacer(),
                    _AvatarWidget(
                      avatar: trip.avatar[2],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: SafeArea(child: CloseButton()),
            ),
          ],
        ),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'back_button',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), shape: BoxShape.circle),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final Avatar avatar;

  _AvatarWidget({@required this.avatar});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> _opacity = ValueNotifier(false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _opacity.value = true;
    });

    return WillPopScope(
      onWillPop: () async {
        _opacity.value = false;

        Navigator.pop(context, true);

        return false;
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
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          this.avatar.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
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
  }
}
