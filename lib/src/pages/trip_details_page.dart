import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:wanderapp/src/models/trip.dart';

class TripDetailsPage extends StatefulWidget {
  final Trip trip;

  TripDetailsPage({@required this.trip});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> with SingleTickerProviderStateMixin {
  final _pageController = PageController(viewportFraction: 0.4);
  AnimationController _animationController;
  ValueNotifier<bool> _showEdit = ValueNotifier(false);

  @override
  void initState() {
    _pageController.addListener(_pageViewScrollControl);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageViewScrollControl);
    _animationController.dispose();
    super.dispose();
  }

  _pageViewScrollControl() {
    final _screenSize = MediaQuery.of(context).size;

    if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
      _pageController.position.animateTo(
        _pageController.position.maxScrollExtent - _screenSize.width * 0.25,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
    if (_pageController.position.pixels == _pageController.position.minScrollExtent) {
      _pageController.position.animateTo(
        _screenSize.width * 0.25,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  _pageViewScrollToStart() {
    _pageController.position.animateTo(
      MediaQuery.of(context).size.width * 0.25,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _toPreviousPage() {
    _animationController.forward();
    _showEdit.value = false;

    Navigator.pop(context, true);
  }
  
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showEdit.value = true;
    });

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          _animationController.forward();
          _showEdit.value = false;

          Navigator.pop(context);

          return false;
        },
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    if (details.primaryDelta > 7) {
                      _toPreviousPage();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Header(
                        toPreviousPage: _toPreviousPage,
                      ),
                      SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Hero(
                          tag: 'title_${widget.trip.title}',
                          child: SizedBox(
                            width: 200,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                widget.trip.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          _AvatarWidget(avatar: widget.trip.avatar.first),
                          const Spacer(),
                          _AvatarWidget(avatar: widget.trip.avatar[1]),
                          const Spacer(),
                          _AvatarWidget(avatar: widget.trip.avatar[2]),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  flex: 4,
                  child: _AnimatedWidget(
                    duration: const Duration(milliseconds: 600),
                    onEnd: _pageViewScrollToStart,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget child) {
                        return Transform.translate(
                          offset: Offset(0.0, _animationController.value * 180),
                          child: Opacity(
                            opacity: (1.0 - _animationController.value * 3).clamp(0.0, 1.0),
                            child: child
                          ),
                        );
                      },
                      child: PageView(
                        controller: _pageController,
                        pageSnapping: false,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          _GeoSummary(),
                          _Media(),
                          _GeoSummary(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _AnimatedWidget(
                          duration: const Duration(milliseconds: 600),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget child) {
                              return Transform.translate(
                                offset: Offset(0.0, _animationController.value * 180),
                                child: child,
                              );
                            },
                            child: Text('TRIP BOARD'),),
                        ),
                        const SizedBox(height: 15),
                        _AnimatedWidget(
                          duration: const Duration(milliseconds: 700),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget child) {
                              return Transform.translate(
                                offset: Offset(0.0, _animationController.value * 180),
                                child: child,
                              );
                            },
                            child: _Chat(
                              image: widget.trip.avatar.first.image,
                              text: 'What a Trip! Thanks for all the memories! What\'s next?',
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _AnimatedWidget(
                          duration: const Duration(milliseconds: 800),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget child) {
                              return Transform.translate(
                                offset: Offset(0.0, _animationController.value * 180),
                                child: child,
                              );
                            },
                            child: _Chat(
                              image: widget.trip.avatar[1].image,
                              text: 'Folks, that was fun. Next time with better car, not that piece of shit! Haha.',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            ValueListenableBuilder(
              valueListenable: _showEdit,
              builder: (BuildContext context, bool value, Widget child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: 30,
                  right: value ? 0 : - 90,
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      width: 75,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xff80a8ff),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback toPreviousPage;

  const _Header({@required this.toPreviousPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Hero(
              tag: 'back_button',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: this.toPreviousPage,
                    child: Ink(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar_10.jpg'),
              radius: 22,
            )
          ],
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
    return Expanded(
      flex: 9,
      child: Container(
        height: 40,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'container_${avatar.image}',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
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
                Hero(
                  tag: 'name_${this.avatar.name}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      this.avatar.name,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                Spacer(flex: 2)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _GeoSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/map.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black26.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'GEO SUMMARY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '1 457 km',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Over 11 days',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Media extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/street.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.deepPurple[900].withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'MEDIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '257',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Photos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '14',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Videos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Chat extends StatelessWidget {
  final String image;
  final String text;

  const _Chat({this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage(
            image,
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            constraints: BoxConstraints(
              maxHeight: 100,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey[400],
                ),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              text,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        )
      ],
    );
  }
}

class _AnimatedWidget extends StatelessWidget {
  final Duration duration;
  final Widget child;
  final VoidCallback onEnd;

  const _AnimatedWidget({
    @required this.duration,
    @required this.child,
    this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: this.duration,
      curve: Curves.easeIn,
      onEnd: onEnd,
      builder: (BuildContext context, value, Widget child) {
        return Transform.translate(
          offset: Offset(0.0, value * 100),
          child: Opacity(
            opacity: (1 - value),
            child: child
          ),
        );
      },
      child: this.child,
    );
  }
}
