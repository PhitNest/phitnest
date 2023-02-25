part of home_page;

class _ExploreEmptyPage extends StatelessWidget {
  const _ExploreEmptyPage() : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          160.verticalSpace,
          Text(
            "More friends\nare on the way.",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Text(
            "The nest is still growing! Please\ncheck again later.",
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          )
        ],
      );
}
