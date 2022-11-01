import 'package:flutter/material.dart';

import '../provider.dart';
import 'news_state.dart';
import 'news_view.dart';

class NewsProvider extends ScreenProvider<NewsState, NewsView> {
  @override
  NewsView build(BuildContext context, NewsState state) => NewsView(
        onPressedLike: () => state.liked = !state.liked,
        title: state.title,
        liked: state.liked,
        onPressedLikePost: state.likePost,
        posts: state.posts,
        likeCount: state.likeCount,
      );

  @override
  NewsState buildState() => NewsState();
}
