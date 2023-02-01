part of gym_search_page;

class _GymSearchState extends ChangeNotifier {
  GymEntity _gym;
  late final TextEditingController searchController = TextEditingController()
    ..addListener(notifyListeners);

  GymEntity get gym => _gym;

  set gym(GymEntity value) {
    _gym = value;
    notifyListeners();
  }

  _GymSearchState(this._gym);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
