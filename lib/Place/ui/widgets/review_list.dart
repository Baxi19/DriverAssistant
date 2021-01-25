import 'package:flutter/material.dart';
import 'review.dart';

// list to show all reviews
class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Review('assets/img/car.jpg', 'Mario K', '2 review, 5 photos', 'There is a best route'),
        Review('assets/img/car2.jpg', 'Luigi', '2 review, 2 photos', 'I like this route'),
        Review('assets/img/car3.jpg', 'Kai 420', '1 review, 19 photos', 'The best way'),
        Review('assets/img/car.jpg', 'Mario K', '2 review, 5 photos', 'I love to travel there'),
        Review('assets/img/car2.jpg', 'Luigi', '2 review, 2 photos', 'It is an accident'),
        Review('assets/img/car3.jpg', 'Crash', '1 review, 30 photos', 'I do not like this route')
      ],
    );
  }
}
