class Trip {
  final String image;
  final DateTime date;
  final String title;
  final List<Avatar> avatar;

  Trip({
    this.image,
    this.date,
    this.title,
    this.avatar,
  });
}

class Avatar {
  final String image;
  final String name;

  Avatar({
    this.image,
    this.name,
  });
}

final trips = <Trip>[
  Trip(
    title: 'Riding through the lands of the legends',
    image: 'assets/puesta_de_sol.jpg',
    date: DateTime(2019, 5, 8),
    avatar: <Avatar>[
      Avatar(image: 'assets/avatar_1.jpg', name: 'Anne'),
      Avatar(image: 'assets/avatar_2.jpg', name: 'Laura'),
      Avatar(image: 'assets/avatar_3.jpg', name: 'Sophia'),
    ],
  ),
  Trip(
    title: 'Weekend in Italy',
    image: 'assets/italy.jpg',
    date: DateTime(2017, 3, 16),
    avatar: [
      Avatar(image: 'assets/avatar_4.jpg', name: 'Emma'),
      Avatar(image: 'assets/avatar_5.jpg', name: 'Olivia'),
      Avatar(image: 'assets/avatar_6.jpg', name: 'Ava'),
    ],
  ),
  Trip(
    title: 'Trip to the tower of Pisa, Paris',
    image: 'assets/eiffel.jpg',
    date: DateTime(2015, 7, 25),
    avatar: [
      Avatar(image: 'assets/avatar_7.jpg', name: 'Isabella'),
      Avatar(image: 'assets/avatar_8.jpg', name: 'Charlotte'),
      Avatar(image: 'assets/avatar_9.jpg', name: 'Mia'),
    ],
  ),
  Trip(
    title: 'Walk around the city',
    image: 'assets/london.jpg',
    date: DateTime(2013, 6, 5),
    avatar: [
      Avatar(image: 'assets/avatar_7.jpg', name: 'Amelia'),
      Avatar(image: 'assets/avatar_8.jpg', name: 'Harper'),
      Avatar(image: 'assets/avatar_9.jpg', name: 'Evelyn'),
    ],
  ),
  Trip(
    title: 'Trip to Roma',
    image: 'assets/romano_antiguo.jpg',
    date: DateTime(2014, 2, 14),
    avatar: [
      Avatar(image: 'assets/avatar_7.jpg', name: 'Abigail'),
      Avatar(image: 'assets/avatar_8.jpg', name: 'Emily'),
      Avatar(image: 'assets/avatar_9.jpg', name: 'Elizabeth'),
    ],
  ),
];
