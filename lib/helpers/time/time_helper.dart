import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:phitnest/constants/constants.dart';

class TimeUtils {
  static String formatTimestamp(int timestamp) {
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  static String setLastSeen(int seconds) {
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    var diff = DateTime.now().millisecondsSinceEpoch - (seconds * 1000);
    if (diff < 24 * HOUR_MILLIS) {
      return format.format(date);
    } else if (diff < 48 * HOUR_MILLIS) {
      return 'Yesterday at ${format.format(date)}'.tr();
    } else {
      format = DateFormat('MMM d');
      return '${format.format(date)}';
    }
  }

  static String audioMessageTime(Duration? audioDuration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitsHours(int n) {
      if (n >= 10) return '$n:';
      if (n == 0) return '';
      return '0$n:';
    }

    String twoDigitMinutes =
        twoDigits(audioDuration?.inMinutes.remainder(60) ?? 0);
    String twoDigitSeconds =
        twoDigits(audioDuration?.inSeconds.remainder(60) ?? 0);
    return '${twoDigitsHours(audioDuration?.inHours ?? 0)}$twoDigitMinutes:$twoDigitSeconds';
  }

  static String updateTime(Timer timer) {
    Duration callDuration = Duration(seconds: timer.tick);
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitsHours(int n) {
      if (n >= 10) return '$n:';
      if (n == 0) return '';
      return '0$n:';
    }

    String twoDigitMinutes = twoDigits(callDuration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(callDuration.inSeconds.remainder(60));
    return '${twoDigitsHours(callDuration.inHours)}$twoDigitMinutes:$twoDigitSeconds';
  }
}
