part of home_page;

class _ExploreMatchedPage extends StatelessWidget {
  final String fullName;
  final VoidCallback onPressedSayHello;
  final VoidCallback onPressedMeetMore;

  const _ExploreMatchedPage({
    Key? key,
    required this.fullName,
    required this.onPressedSayHello,
    required this.onPressedMeetMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black,
        child: Column(
          children: [
            240.verticalSpace,
            Text("$fullName\nwants to meet you too!",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium!
                    .copyWith(color: Colors.white)),
            40.verticalSpace,
            StyledButton(
              text: "SAY HELLO",
              onPressed: onPressedSayHello,
            ),
            Spacer(),
            StyledUnderlinedTextButton(
              text: 'MEET MORE FRIENDS',
              onPressed: onPressedMeetMore,
            ),
            28.verticalSpace,
          ],
        ),
      );
}
