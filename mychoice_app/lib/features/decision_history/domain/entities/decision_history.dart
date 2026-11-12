/// Entitas domain untuk riwayat keputusan pengguna.
class DecisionHistory {
  const DecisionHistory({
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
  final int rating; // 0 = belum diberi rating, 1-5 = bintang dari user
  final String? review; // ulasan teks dari user

  /// Status turunan berdasarkan apakah sudah diberi rating atau belum.
  String get status => rating > 0 ? 'Rated' : 'Decision Made';

  /// Buat salinan dengan penggantian field opsional.
  DecisionHistory copyWith({
    String? id,
    String? userId,
    String? category,
    String? subcategory,
    String? title,
    double? score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? rating,
    String? review,
  }) {
    return DecisionHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      title: title ?? this.title,
      score: score ?? this.score,
      finalOption: finalOption ?? this.finalOption,
      decisionDate: decisionDate ?? this.decisionDate,
      priorities: priorities ?? this.priorities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  @override
  String toString() =>
      'DecisionHistory(id: $id, title: $title, score: $score, rating: $rating)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DecisionHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
