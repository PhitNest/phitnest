part of message;

class MessagePage extends StatelessWidget {
  final HomeBloc homeBloc;
  final PopulatedFriendshipEntity friendship;

  const MessagePage({
    Key? key,
    required this.homeBloc,
    required this.friendship,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: homeBloc,
        child: BlocConsumer<HomeBloc, IHomeState>(
          listener: (context, state) {},
          builder: (context, state) => ,
        ),
      );
}
