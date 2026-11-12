import '../entities/decision_history.dart';

/// Antarmuka repository untuk riwayat keputusan dan ulasan/bintang rating.
abstract class DecisionHistoryRepository {
  /// Simpan riwayat keputusan baru.
  Future<DecisionHistory> createDecisionHistory({
    required String category,
    String? subcategory,
    required String title,
    required double score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
  });

  /// Ambil daftar riwayat keputusan milik user login (terbaru dulu), lengkap
  /// dengan rating dan ulasan jika ada.
  Future<List<DecisionHistory>> getDecisionHistories();

  /// Ambil satu detail riwayat keputusan beserta ulasan & rating.
  Future<DecisionHistory?> getDecisionHistoryById(String id);

  /// Perbarui ulasan dan bintang rating pada riwayat keputusan.
  /// [rating] harus berada dalam rentang 1 sampai 5.
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  });

  /// Hapus riwayat keputusan milik user login.
  Future<void> deleteDecisionHistory(String id);
}
