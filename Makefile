#!Make

codegen:
	flutter pub run build_runner build --delete-conflicting-outputs

run: codegen
	flutter run