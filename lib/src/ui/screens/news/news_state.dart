import '../state.dart';

class NewsState extends ScreenState {
  final dummy_data = [
    {
      'title': 'New member',
      'subtitle': 'Peter H Just Joined your nest',
      'status': 1
    },
    {
      'title': 'New member',
      'subtitle': 'John Just Joined your nest',
      'status': 2
    },
    {
      'title': 'New member',
      'subtitle': 'Hussey Just Joined your nest',
      'status': 1
    },
    {
      'title': 'Friend request',
      'subtitle': 'Erin-Michelle J. wants to be your friend',
      'status': 3
    },
    {
      'title': 'New member',
      'subtitle': 'Koustav Just Joined your nest',
      'status': 1
    },
    {
      'title': 'New member',
      'subtitle': 'Turner wants to be your friend',
      'status': 2
    },
    {
      'title': 'New member',
      'subtitle': 'Umaar Just Joined your nest',
      'status': 2
    }
  ];
  int status = 1;

  void onPressedLiked() {
    status == 1 ? status = 2 : status = 1;
  }
}
