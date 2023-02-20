part of explore_page;

class _EmptyNestPage extends StatelessWidget {
  const _EmptyNestPage() : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          200.verticalSpace,
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
