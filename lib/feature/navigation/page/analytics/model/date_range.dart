enum DateRange {
  last7Days('7d'),
  last30Days('30d'),
  last6Months('6m'),
  last1Year('1y');

  final String value;
  const DateRange(this.value);
}
