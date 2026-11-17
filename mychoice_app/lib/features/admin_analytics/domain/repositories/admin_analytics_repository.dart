import '../entities/admin_review.dart';

abstract class AdminAnalyticsRepository {
  Future<List<AdminReview>> getReviews();
}
