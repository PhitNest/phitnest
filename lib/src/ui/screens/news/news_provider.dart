import 'package:flutter/material.dart';

import '../provider.dart';
import 'news_state.dart';
import 'news_view.dart';

class NewsProvider extends ScreenProvider<NewsState, NewsView> {
  @override
  NewsView build(BuildContext context, NewsState state) => NewsView(
      onPressedLiked: state.onPressedLiked,
      status: state.status,
      dummyData: state.dummy_data);

  @override
  NewsState buildState() => NewsState();
}
