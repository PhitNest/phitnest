import 'package:flutter/material.dart';

import '../provider.dart';
import 'news_state.dart';
import 'news_view.dart';

class NewsProvider extends ScreenProvider<NewsState, NewsView> {
  @override
  NewsView build(BuildContext context, NewsState state) => NewsView();

  @override
  NewsState buildState() => NewsState();
}
