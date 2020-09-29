import 'package:flutter/material.dart';

import 'lang.dart';

String timerFormat(int value) {
  if (value == null) {
    return '--:--';
  }

  value = value;

  var second = "${((value % 60).floor() < 10 ? 0 : '')}${(value % 60).floor()}";

  var minutes = "${(value / 60).floor()}";

  var hours = '00';

  if (int.parse(minutes) < 10) {
    minutes = "0$minutes";
  }

  if (int.parse(minutes) >= 60) {
    hours = (int.parse(minutes) / 60).floor() as String;
    minutes = (minutes as int) % 60 as String;

    if (int.parse(minutes) < 10) {
      minutes = ('0$minutes');
    }
  }

  return '${hours != '00' ? hours + ':' : ''}$minutes:$second';
}

EdgeInsets getMargin() {
  if (lang.isRtl()) {
    return const EdgeInsets.only(left: 4.0);
  } else {
    return const EdgeInsets.only(right: 4.0);
  }
}

String getStatus(String status) {
  switch (status) {
    case "new":
      return lang.text("New");
    case "confirm":
      return lang.text("Confirmed Student");
    case "registered":
      return lang.text("Registered");
    case "refused":
      return lang.text("Refused");
    default:
      return lang.text("Pending");
  }
}

String getDay(String day) {
  switch (day) {
    case "saturday":
      return lang.text("Saturday");
    case "sunday":
      return lang.text("Sunday");
    case "monday":
      return lang.text("Registered");
    case "monday":
      return lang.text("Monday");
    case "tuesday":
      return lang.text("Tuesday");
    case "wednesday":
      return lang.text("Wednesday");
    case "thursday":
      return lang.text("Thursday");
    case "friday":
      return lang.text("Friday");
    default:
      return lang.text("Pending");
  }
}
