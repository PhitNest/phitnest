import 'package:flutter/material.dart';

class ActivityPost extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool liked;

  const ActivityPost(
      {required this.title, required this.subtitle, this.liked = false})
      : super();

  @override
  Widget build(BuildContext context) => Container();
}
