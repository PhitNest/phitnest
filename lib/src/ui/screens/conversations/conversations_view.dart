import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/conversation_card.dart';

class ConversationsView extends ScreenView {
  final List<ConversationCard> conversations;
  final VoidCallback onClickFriends;
  final VoidCallback onTapLogoButton;
  final VoidCallback onPressedRetry;
  final bool loading;
  final String? errorMessage;

  ConversationsView({
    required this.conversations,
    required this.onClickFriends,
    required this.onTapLogoButton,
    required this.onPressedRetry,
    required this.loading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              40.verticalSpace,
              Container(
                width: 0.9.sw,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClickFriends,
                  child: Text(
                    'FRIENDS',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: loading || errorMessage != null
                    ? Center(
                        child: loading
                            ? CircularProgressIndicator()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    errorMessage ?? "",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(color: Colors.red),
                                  ),
                                  20.verticalSpace,
                                  StyledButton(
                                    onPressed: onPressedRetry,
                                    child: Text(
                                      "RETRY",
                                    ),
                                  )
                                ],
                              ),
                      )
                    : conversations.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: conversations.length,
                            itemBuilder: (context, index) =>
                                conversations[index],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              100.verticalSpace,
                              Text(
                                "You have no messages",
                                style: theme.textTheme.headlineLarge,
                                textAlign: TextAlign.center,
                              ),
                              40.verticalSpace,
                              Text(
                                "Go explore and meet new friends!",
                                style: theme.textTheme.labelLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
              ),
              StyledNavBar(
                pageIndex: 2,
                onTapDownLogo: onTapLogoButton,
                navigationEnabled: true,
              ),
            ],
          ),
        ),
      );
}
