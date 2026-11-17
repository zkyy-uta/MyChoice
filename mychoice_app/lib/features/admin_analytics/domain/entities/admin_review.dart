class AdminReview {
  const AdminReview({
    required this.id,
    required this.userId,
    required this.decisionTitle,
    required this.createdAt,
    required this.rating,
    this.review,
  });

  final String id;
  final String userId;
  final String decisionTitle;
  final DateTime createdAt;
  final int rating;
  final String? review;
}
