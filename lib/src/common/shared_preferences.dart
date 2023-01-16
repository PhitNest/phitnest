import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;

Future<void> loadPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
}
