import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../category_selection/data/datasources/supabase_subcategory_lookup.dart';
import '../../domain/entities/alternative.dart';
import '../../domain/repositories/personal_alternative_repository.dart';

class SupabasePersonalAlternativeRepository
    implements PersonalAlternativeRepository {
  SupabasePersonalAlternativeRepository(this._client);

  final SupabaseClient _client;

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('Sign in before using your personal catalog.');
    }
    return user.id;
  }

  Alternative _mapRow(Map<String, dynamic> row) {
    final attributes = row['atribut'];
    return Alternative(
      id: row['id_pilihan_pengguna'] as String,
      name: row['nama_pilihan'] as String,
      source: 'custom',
      specs: attributes is Map
          ? Map<String, dynamic>.from(attributes)
          : const <String, dynamic>{},
    );
  }

  @override
  Future<List<Alternative>> getMyOptions({
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
          .from('pilihan_katalog_pengguna')
          .select('id_pilihan_pengguna,nama_pilihan,atribut')
          .eq('id_pengguna', userId)
          .eq('id_sub_kategori', subcategoryId)
          .order('nama_pilihan');
      return (rows as List<dynamic>)
          .map((row) => _mapRow(Map<String, dynamic>.from(row as Map)))
          .toList();
    } on PostgrestException catch (error) {
      throw Exception('Failed to load your saved options: ${error.message}');
    }
  }

  @override
  Future<Alternative> addMyOption({
    required String category,
    required String subcategory,
    required String name,
    required Map<String, dynamic> attributes,
  }) async {
    final userId = _userId;
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('Option name cannot be empty.');
    }
    if (attributes.isEmpty ||
        attributes.values.any((value) => value.toString().trim().isEmpty)) {
      throw ArgumentError('Every comparison criterion needs a value.');
    }

    try {
      final subcategoryId = await SupabaseSubcategoryLookup.getId(
        _client,
        category: category,
        subcategory: subcategory,
      );
      final row = await _client
          .from('pilihan_katalog_pengguna')
          .insert({
            'id_pengguna': userId,
            'id_sub_kategori': subcategoryId,
            'nama_pilihan': normalizedName,
            'atribut': attributes,
          })
          .select('id_pilihan_pengguna,nama_pilihan,atribut')
          .single();
      return _mapRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw StateError(
          'An option with this name already exists in your subcategory.',
        );
      }
      throw Exception('Failed to save your option: ${error.message}');
    }
  }

  @override
  Future<Alternative> updateMyOption({
    required String id,
    required String name,
    required Map<String, dynamic> attributes,
  }) async {
    final userId = _userId;
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('Option name cannot be empty.');
    }
    if (attributes.isEmpty ||
        attributes.values.any((value) => value.toString().trim().isEmpty)) {
      throw ArgumentError('Every comparison criterion needs a value.');
    }

    try {
      final row = await _client
          .from('pilihan_katalog_pengguna')
          .update({'nama_pilihan': normalizedName, 'atribut': attributes})
          .eq('id_pengguna', userId)
          .eq('id_pilihan_pengguna', id)
          .select('id_pilihan_pengguna,nama_pilihan,atribut')
          .maybeSingle();
      if (row == null) {
        throw StateError('The saved option was not found in your account.');
      }
      return _mapRow(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw StateError(
          'An option with this name already exists in your subcategory.',
        );
      }
      throw Exception('Failed to update your option: ${error.message}');
    }
  }

  @override
  Future<void> deleteMyOption({required String id}) async {
    final userId = _userId;
    try {
      final rows = await _client
          .from('pilihan_katalog_pengguna')
          .delete()
          .eq('id_pengguna', userId)
          .eq('id_pilihan_pengguna', id)
          .select('id_pilihan_pengguna');
      if ((rows as List<dynamic>).isEmpty) {
        throw StateError('The saved option was not found in your account.');
      }
    } on PostgrestException catch (error) {
      throw Exception('Failed to delete your option: ${error.message}');
    }
  }
}
