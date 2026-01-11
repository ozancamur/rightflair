class AnalyticsModel {
  final String shareCount;
  final String likeCount;
  final String followerCount;
  final String saveCount;

  final double shareGrowth;
  final double likeGrowth;
  final double followerGrowth;
  final double saveGrowth;

  final List<double> engagementData; // For the chart

  const AnalyticsModel({
    required this.shareCount,
    required this.likeCount,
    required this.followerCount,
    required this.saveCount,
    required this.shareGrowth,
    required this.likeGrowth,
    required this.followerGrowth,
    required this.saveGrowth,
    required this.engagementData,
  });

  // Mock data
  static AnalyticsModel get mock => AnalyticsModel(
    shareCount: "24.5k",
    likeCount: "3,204",
    followerCount: "892",
    saveCount: "415",
    shareGrowth: 12.4,
    likeGrowth: 8.2,
    followerGrowth: -1.4,
    saveGrowth: 24.0,
    engagementData: [
      1.0,
      3.0,
      2.5,
      4.0,
      5.5,
      5.0,
      4.5,
    ], // Normalized 0-6 range for example
  );
}
