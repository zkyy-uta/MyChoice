import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/admin_review.dart';
import '../../domain/repositories/admin_analytics_repository.dart';

class SupabaseAdminAnalyticsRepository implements AdminAnalyticsRepository {
  SupabaseAdminAnalyticsRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<AdminReview>> getReviews() async {
    try {
      final rows = await _client
          .from('decision_history_reviews')
          .select(
            'id,user_id,rating,review,created_at,decision_histories(title)',
          )
          .order('created_at', ascending: false);
      return (rows as List<dynamic>).map((row) {
        final item = Map<String, dynamic>.from(row as Map);
        final decision = item['decision_histories'];
        final title = decision is Map ? decision['title'] as String? ?? '' : '';
        return AdminReview(
          id: item['id'] as String,
          userId: item['user_id'] as String,
          decisionTitle: title,
          createdAt: DateTime.parse(item['created_at'] as String),
          rating: (item['rating'] as num).toInt(),
          review: item['review'] as String?,
        );
      }).toList();
    } on PostgrestException catch (error) {
      throw Exception('Failed to load user reviews: ${error.message}');
    }
  }
}
