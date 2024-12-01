String countFormat(int count) {
  String formattedCount = "";
  if (count >= 1000000) {
    formattedCount =
        "${(count / 1000000).toStringAsFixed(1)}M"; // 1.2M for million
  } else if (count >= 1000) {
    formattedCount =
        "${(count / 1000).toStringAsFixed(1)}K"; // 12.3K for thousand
  } else {
    formattedCount = count.toString(); // 999 or below remains as is
  }
  return formattedCount;
}

String durationTransform(int seconds) {
  int m = (seconds / 60).truncate();
  int s = seconds - m * 60;
  if (s < 10) {
    return '$m:0$s';
  }
  return '$m:$s';
}
