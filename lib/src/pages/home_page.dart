import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'package:wanderapp/src/models/trip.dart';
import 'package:wanderapp/src/pages/trip_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  _onTap(BuildContext context, Trip trip) async {

    _animationController.forward();

    final result = await Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: TripPage(trip: trip),
        );
      },
    ));

    if (result) _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 5.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _HeaderWidget(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget child) {
                    return Transform.translate(
                      offset: Offset(0.0, (_animationController.value) * - 30),
                      child: child,
                    );
                  },
                  child: Text(
                    'Your trips',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform.translate(
                              offset: Offset(0.0, (_animationController.value) * - 30),
                              child: child,
                            );
                          },
                          child: Text(
                            'CURRENT TRIP',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _TripWidget(
                          main: true,
                          trip: trips.first,
                          onTap: () => _onTap(context, trips.first),
                        ),
                        const SizedBox(height: 30),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform.translate(
                              offset: Offset(0.0, (_animationController.value) * 50),
                              child: Opacity(
                                opacity: (1 - _animationController.value),
                                child: child
                              ),
                            );
                          },
                          child: Text(
                            'PAST TRIPS',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 3 / 3.5,
                      crossAxisSpacing: 15.0,
                      children: trips.getRange(1, trips.length).map((trip) {
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform.translate(
                              offset: Offset(0.0, (_animationController.value) * 50),
                              child: child,
                            );
                          },
                          child: _TripWidget(
                            trip: trip,
                            onTap: () => _onTap(context, trip),
                          ),
                        );
                      }).toList(),
                    ),
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 10),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TripWidget extends StatelessWidget {
  final bool main;
  final Trip trip;
  final VoidCallback onTap;

  const _TripWidget({
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
                  SizedBox(height: main ? 15 : 10),
                  Hero(
                    tag: 'title_${trip.title}',
                    child: Material(
                      type: MaterialType.transparency,
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
                child: _AvatarWidget(
                  image: avatar.image,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final String image;

  const _AvatarWidget({@required this.image});

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
  }
}

class _HeaderWidget extends StatelessWidget {
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
