import 'package:basic_utils/basic_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

String _wrapText(String text) =>
    StringUtils.addCharAtPosition(text, '\n\t', 100, repeat: true);

final _prettyLogger = Logger(printer: PrettyPrinter(methodCount: 0));

void debug(String message) => _prettyLogger.d(_wrapText(message));

void info(String message) => _prettyLogger.i(_wrapText(message));

void warning(String message) => _prettyLogger.w(_wrapText(message));

void error(String message) => _prettyLogger.e(_wrapText(message));

void badState(Equatable state, Equatable event) =>
    error('$state:\n\tInvalid event: $event');
