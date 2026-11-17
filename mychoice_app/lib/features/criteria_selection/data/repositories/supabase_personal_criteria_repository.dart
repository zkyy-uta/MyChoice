import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../category_selection/data/datasources/supabase_subcategory_lookup.dart';
import '../../domain/repositories/personal_criteria_repository.dart';

class SupabasePersonalCriteriaRepository implements PersonalCriteriaRepository {
  SupabasePersonalCriteriaRepository(this._client);

  final SupabaseClient _client;

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('Sign in before using your personal criteria.');
    }
    return user.id;
  }

  @override
  Future<List<String>> getMyCriteria({
    required String category,
    required String subcategory,
  }) async {
    final userId = _userId;
    try {
      final subcategoryId = await SupabaseSubcategoryLookup.getId(
        _client,
        category: category,
        subcategory: subcategory,
      );
      final rows = await _client
          .from('kriteria_personal_pengguna')
          .select('nama_kriteria')
          .eq('id_pengguna', userId)
          .eq('id_sub_kategori', subcategoryId)
          .order('nama_kriteria');
      return (rows as List<dynamic>)
          .map(
            (row) =>
                Map<String, dynamic>.from(row as Map)['nama_kriteria']
                    as String,
          )
          .toList();
    } on PostgrestException catch (error) {
      throw Exception(
        'Failed to load your personal criteria: ${error.message}',
      );
    }
  }

  @override
  Future<String> addMyCriterion({
    required String category,
    required String subcategory,
    required String name,
  }) async {
    final userId = _userId;
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || normalizedName.length > 100) {
      throw ArgumentError('Criterion name must contain 1 to 100 characters.');
    }

    try {
      final subcategoryId = await SupabaseSubcategoryLookup.getId(
        _client,
        category: category,
        subcategory: subcategory,
      );
      final row = await _client
          .from('kriteria_personal_pengguna')
          .insert({
            'id_pengguna': userId,
            'id_sub_kategori': subcategoryId,
            'nama_kriteria': normalizedName,
          })
          .select('nama_kriteria')
          .single();
      return Map<String, dynamic>.from(row)['nama_kriteria'] as String;
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw StateError(
          'This criterion is already saved for this subcategory.',
        );
      }
      throw Exception(
        'Failed to save your personal criterion: ${error.message}',
      );
    }
  }
}
