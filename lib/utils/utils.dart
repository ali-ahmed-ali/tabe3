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
