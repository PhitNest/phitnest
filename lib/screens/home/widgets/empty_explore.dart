part of '../home.dart';

final class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) => const Center(
        child: Text('There are no users to explore.'),
      );
}
