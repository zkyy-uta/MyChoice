import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSubcategoryLookup {
  const SupabaseSubcategoryLookup._();

  static Future<int> getId(
    SupabaseClient client, {
    required String category,
    required String subcategory,
  }) async {
    final row = await client
        .from('subcategories')
        .select('id_sub_kategori,categories!inner(nama_kategori)')
        .eq('nama_sub_kategori', subcategory)
        .eq('categories.nama_kategori', category)
        .maybeSingle();

    if (row == null) {
      throw StateError(
        'The subcategory "$subcategory" was not found in "$category".',
      );
    }
    final id = row['id_sub_kategori'];
    if (id is! num) {
      throw const FormatException('The subcategory ID is invalid.');
    }
    return id.toInt();
  }
}
