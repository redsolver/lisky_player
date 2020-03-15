class Util {
  static String renderDuration(durationInMs) {
    int durationMs = durationInMs.round();

    int seconds = ((durationMs) / 1000).round();

    int minutes = (seconds / 60).floor();
    seconds = seconds - (minutes * 60);

    String minStr = minutes.toString();
    String secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }
}
