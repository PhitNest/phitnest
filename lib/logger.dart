import 'package:basic_utils/basic_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

String _wrapText(String line, int spaces) => StringUtils.addCharAtPosition(
      line,
      '\n${List.filled(spaces, '\t').join('')}',
      100,
      repeat: true,
    );

final _prettyLogger = Logger(printer: PrettyPrinter(methodCount: 0));

String _logMessage(String title, List<String>? details) => '$title'
    '${details != null ? '\n${details.map((e) {
        return _wrapText(e, 1);
      }).join('\n')}' : ''}';

void debug(String title, {List<String>? details}) =>
    _prettyLogger.d(_logMessage(title, details));

void info(String title, {List<String>? details}) =>
    _prettyLogger.i(_logMessage(title, details));

void warning(String title, {List<String>? details}) =>
    _prettyLogger.w(_logMessage(title, details));

void error(String title, {List<String>? details}) =>
    _prettyLogger.e(_logMessage(title, details));

void badState(Equatable state, Equatable event) =>
    error('$state:\n\tInvalid event: $event');
