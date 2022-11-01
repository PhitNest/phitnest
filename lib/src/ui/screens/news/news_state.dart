import '../state.dart';
import 'models/activity_post.dart';

class NewsState extends ScreenState {
  final String title = "Planet Fitness";
  final String likeCount = "1.1k";

  bool _liked = false;

  bool get liked => _liked;

  set liked(bool liked) {
    _liked = liked;
    rebuildView();
  }

  List<ActivityPostModel> posts = [
    ActivityPostModel(
        title: 'New member',
        subtitle: 'John Just Joined your nest',
        liked: false),
    ActivityPostModel(
        title: 'New member',
        subtitle: 'Hussey Just Joined your nest',
        liked: true),
    ActivityPostModel(
        title: 'Friend request',
        subtitle: 'Erin-Michelle J. wants to be your friend'),
    ActivityPostModel(
        title: 'New member',
        subtitle: 'Koustav Just Joined your nest',
        liked: false),
    ActivityPostModel(
        title: 'New member',
        subtitle: 'Turner wants to be your friend',
        liked: true),
    ActivityPostModel(
        title: 'New member',
        subtitle: 'Umaar Just Joined your nest',
        liked: true),
  ];

  likePost(int index) {
    posts[index].liked = !posts[index].liked!;
    rebuildView();
  }
}
