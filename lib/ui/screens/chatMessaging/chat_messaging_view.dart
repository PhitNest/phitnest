import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ChatMessagingView extends ScreenView {
  final String fullName;

  const ChatMessagingView({
    Key? key,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BackButtonAppBar(),
        body: Center(child: Text(fullName)),
      );
}
