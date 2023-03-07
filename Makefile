#!make
codegen:
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs

run: codegen
	flutter run