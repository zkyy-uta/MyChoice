import '../../domain/entities/decision_history.dart';

/// Model data untuk riwayat keputusan (dikirim/diterima dari Supabase).
class DecisionHistoryModel {
  const DecisionHistoryModel({
    required this.id,
    required this.userId,
    required this.category,
    this.subcategory,
    required this.title,
    required this.score,
    this.finalOption,
    required this.decisionDate,
    this.priorities = const {},
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0,
    this.review,
  });

  final String id;
  final String userId;
  final String category;
  final String? subcategory;
  final String title;
  final double score;
  final String? finalOption;
  final DateTime decisionDate;
  final Map<String, dynamic> priorities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int rating;
  final String? review;

  factory DecisionHistoryModel.fromJson(Map<String, dynamic> json) {
    return DecisionHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      title: json['title'] as String,
      score: (json['score'] as num).toDouble(),
      finalOption: json['final_option'] as String?,
      decisionDate: DateTime.tryParse(json['decision_date'] as String? ?? '') ??
          DateTime.now(),
      priorities: (json['priorities'] as Map<String, dynamic>?) ?? const {},
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      review: json['review'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'subcategory': subcategory,
      'title': title,
      'score': score,
      'final_option': finalOption,
      'decision_date': decisionDate.toIso8601String(),
      'priorities': priorities,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'review': review,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'category': category,
      'subcategory': subcategory,
      'title': title,
      'score': score,
      'final_option': finalOption,
      'decision_date': decisionDate.toIso8601String(),
      'priorities': priorities,
    };
  }

  /// Payload untuk memperbarui ulasan dan bintang rating.
  Map<String, dynamic> toReviewJson({
    required int rating,
    String? review,
  }) {
    return {
      'rating': rating,
      'review': review,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  DecisionHistory toEntity() {
    return DecisionHistory(
      id: id,
      userId: userId,
      category: category,
      subcategory: subcategory,
      title: title,
      score: score,
      finalOption: finalOption,
      decisionDate: decisionDate,
      priorities: priorities,
      createdAt: createdAt,
      updatedAt: updatedAt,
      rating: rating,
      review: review,
    );
  }

  @override
  String toString() =>
      'DecisionHistoryModel(id: $id, title: $title, score: $score, rating: $rating)';
}
