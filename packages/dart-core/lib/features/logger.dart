import 'package:basic_utils/basic_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

const kDetailLinePrefix = '\n\t';

final _prettyLogger = Logger(printer: PrettyPrinter(methodCount: 0));

String _wrapText(String text, int spaces) => StringUtils.addCharAtPosition(
      text,
      '\n${List.filled(spaces, '\t').join()}',
      100,
      repeat: true,
    );

String _logMessage(String title, List<String>? details) =>
    '${_wrapText(title, 0)}'
    '${details != null ? '$kDetailLinePrefix'
        '${details.map((e) => _wrapText(e, 2)).join(kDetailLinePrefix)}' : ''}';

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
