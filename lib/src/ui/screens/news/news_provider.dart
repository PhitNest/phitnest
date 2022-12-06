import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'news_state.dart';
import 'news_view.dart';

class NewsProvider extends ScreenProvider<NewsState, NewsView> {
  const NewsProvider() : super();

  @override
  NewsView build(BuildContext context, NewsState state) => NewsView(
        onPressedLike: state.likePost,
        title: state.title,
        posts: state.posts,
        onPressedLogo: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => const ExploreProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  NewsState buildState() => NewsState();
}
