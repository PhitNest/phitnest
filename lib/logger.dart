import 'package:basic_utils/basic_utils.dart';
import 'package:logger/logger.dart';

String wrapText(String text) =>
    StringUtils.addCharAtPosition(text, '\n\t', 100, repeat: true);

final prettyLogger = Logger(printer: PrettyPrinter(methodCount: 0));
