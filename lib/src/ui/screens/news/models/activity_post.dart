class ActivityPostModel {
  final String title;
  final String subtitle;
  bool? liked;

  ActivityPostModel({
    required this.title,
    required this.subtitle,
    this.liked,
  });
}
