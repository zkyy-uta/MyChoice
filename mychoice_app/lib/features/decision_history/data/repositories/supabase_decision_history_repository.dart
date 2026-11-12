import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/decision_history.dart';
import '../../domain/repositories/decision_history_repository.dart';
import '../models/decision_history_model.dart';

/// Implementasi repository riwayat keputusan menggunakan Supabase.
class SupabaseDecisionHistoryRepository implements DecisionHistoryRepository {
  SupabaseDecisionHistoryRepository(this._client);

  final SupabaseClient _client;

  /// ID user yang sedang login (diambil dari sesi Supabase Auth).
  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AuthenticationError(message: 'User belum login.');
    }
    return user.id;
  }

  @override
  Future<DecisionHistory> createDecisionHistory({
    required String category,
    String? subcategory,
    required String title,
    required double score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
  }) async {
    final model = DecisionHistoryModel(
      id: '', // akan diisi oleh database
      userId: _currentUserId,
      category: category,
      subcategory: subcategory,
      title: title,
      score: score,
      finalOption: finalOption,
      decisionDate: decisionDate ?? DateTime.now(),
      priorities: priorities ?? const {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final response = await _client
          .from('decision_histories')
          .insert(model.toInsertJson())
          .select()
          .single();

      final created = DecisionHistoryModel.fromJson(response);
      return created.toEntity();
    } on PostgrestException catch (e) {
      throw Exception('Gagal menyimpan riwayat keputusan: ${e.message}');
    } on Object catch (e) {
      throw Exception('Gagal menyimpan riwayat keputusan: $e');
    }
  }

  @override
  Future<List<DecisionHistory>> getDecisionHistories() async {
    final userId = _currentUserId;

    try {
      // Query decision_histories langsung dengan left join ke reviews
      final response = await _client
          .from('decision_histories')
          .select('''
            *,
            decision_history_reviews (
              rating,
              review,
              updated_at
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((e) {
        final row = Map<String, dynamic>.from(e as Map);
        // Flatten review data ke level atas agar model bisa parsing
        final reviews = row['decision_history_reviews'] as List<dynamic>?;
        if (reviews != null && reviews.isNotEmpty) {
          final reviewData = Map<String, dynamic>.from(reviews.first as Map);
          row['rating'] = reviewData['rating'];
          row['review'] = reviewData['review'];
        }
        return DecisionHistoryModel.fromJson(row).toEntity();
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal memuat riwayat keputusan: ${e.message}');
    } on Object catch (e) {
      throw Exception('Gagal memuat riwayat keputusan: $e');
    }
  }

  @override
  Future<DecisionHistory?> getDecisionHistoryById(String id) async {
    final userId = _currentUserId;

    try {
      final response = await _client
          .from('decision_histories')
          .select('''
            *,
            decision_history_reviews (
              rating,
              review,
              updated_at
            )
          ''')
          .eq('id', id)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      final data = Map<String, dynamic>.from(response as Map);

      // Gabungkan data ulasan ke level atas agar model dapat mem-parsinya
      final reviews = data['decision_history_reviews'] as List<dynamic>?;
      if (reviews != null && reviews.isNotEmpty) {
        final reviewData = Map<String, dynamic>.from(reviews.first as Map);
        data['rating'] = reviewData['rating'];
        data['review'] = reviewData['review'];
        data['updated_at'] = reviewData['updated_at'] ?? data['updated_at'];
      }

      return DecisionHistoryModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw Exception('Gagal memuat detail riwayat: ${e.message}');
    } on Object catch (e) {
      throw Exception('Gagal memuat detail riwayat: $e');
    }
  }

  @override
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {
    final userId = _currentUserId;

    if (rating < 1 || rating > 5) {
      throw Exception('Rating harus antara 1 dan 5 bintang.');
    }

    try {
      // Cek apakah ulasan sudah ada untuk riwayat ini
      final existing = await _client
          .from('decision_history_reviews')
          .select('id')
          .eq('decision_history_id', decisionHistoryId)
          .eq('user_id', userId)
          .maybeSingle();

      final payload = {
        'rating': rating,
        'review': review,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (existing == null) {
        // Buat ulasan baru
        await _client.from('decision_history_reviews').insert({
          'decision_history_id': decisionHistoryId,
          'user_id': userId,
          ...payload,
        });
      } else {
        // Perbarui ulasan yang sudah ada
        await _client
            .from('decision_history_reviews')
            .update(payload)
            .eq('id', existing['id'] as String)
            .eq('user_id', userId);
      }

      // Perbarui updated_at pada decision_histories juga
      await _client
          .from('decision_histories')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('id', decisionHistoryId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menyimpan ulasan dan rating: ${e.message}');
    } on Object catch (e) {
      throw Exception('Gagal menyimpan ulasan dan rating: $e');
    }
  }

  @override
  Future<void> deleteDecisionHistory(String id) async {
    final userId = _currentUserId;

    try {
      await _client
          .from('decision_histories')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus riwayat keputusan: ${e.message}');
    } on Object catch (e) {
      throw Exception('Gagal menghapus riwayat keputusan: $e');
    }
  }
}
