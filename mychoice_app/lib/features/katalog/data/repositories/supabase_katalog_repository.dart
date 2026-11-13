import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/katalog_item.dart';
import '../../domain/repositories/katalog_repository.dart';

/// Implementasi katalog menggunakan Supabase (tabel pilihan_katalog + relasi).
class SupabaseKatalogRepository implements KatalogRepository {
  SupabaseKatalogRepository(this._client);

  final SupabaseClient _client;

  List<KatalogItem> _mapRows(List<dynamic> rows) {
    return rows.map((r) {
      final m = Map<String, dynamic>.from(r as Map);
      final sub = m['sub_kategori'] as Map?;
      final namaSubKategori = sub?['nama_sub_kategori'] as String?;
      final kategori = sub?['kategori'] as Map?;
      final namaKategori = kategori?['nama_kategori'] as String?;
      return KatalogItem.fromMap({
        ...m,
        'nama_sub_kategori': namaSubKategori,
        'nama_kategori': namaKategori,
      });
    }).toList();
  }

  @override
  Future<List<KatalogItem>> getKatalog({
    String? kategori,
    String? subKategori,
  }) async {
    try {
      var query = _client
          .from('pilihan_katalog')
          .select('''
            id_pilihan_katalog,
            id_sub_kategori,
            nama_pilihan,
            harga,
            spesifikasi,
            rating,
            sub_kategori!inner(nama_sub_kategori, kategori!inner(nama_kategori))
          ''')
          .order('nama_pilihan');

      if (kategori != null && kategori.isNotEmpty) {
        query = query.eq('sub_kategori.kategori.nama_kategori', kategori);
      }
      if (subKategori != null && subKategori.isNotEmpty) {
        query = query.eq('sub_kategori.nama_sub_kategori', subKategori);
      }

      final response = await query;
      return _mapRows(response as List<dynamic>);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memuat katalog: ${e.message}');
    } catch (e) {
      throw Exception('Gagal memuat katalog: $e');
    }
  }

  @override
  Future<List<KatalogItem>> getBySubKategori(String namaSubKategori) async {
    return getKatalog(subKategori: namaSubKategori);
  }

  @override
  Future<KatalogItem?> getById(String idPilihanKatalog) async {
    try {
      final response = await _client
          .from('pilihan_katalog')
          .select('''
            id_pilihan_katalog,
            id_sub_kategori,
            nama_pilihan,
            harga,
            spesifikasi,
            rating,
            sub_kategori!inner(nama_sub_kategori, kategori!inner(nama_kategori))
          ''')
          .eq('id_pilihan_katalog', idPilihanKatalog)
          .maybeSingle();

      if (response == null) return null;
      return _mapRows([response])[0];
    } on PostgrestException catch (e) {
      throw Exception('Gagal memuat detail barang: ${e.message}');
    } catch (e) {
      throw Exception('Gagal memuat detail barang: $e');
    }
  }

  @override
  Future<Map<String, int>> reseedKatalog({
    required List<Map<String, dynamic>> kategori,
    required List<Map<String, dynamic>> subKategori,
    required List<Map<String, dynamic>> pilihanKatalog,
  }) async {
    try {
      final response = await _client.functions.invoke('seed-catalog', body: {
        'kategori': kategori,
        'sub_kategori': subKategori,
        'pilihan_katalog': pilihanKatalog,
        'reseed': true,
      });
      final detail = response['detail'] as Map? ?? {};
      return detail.map((key, value) => MapEntry(key as String, (value as num).toInt()));
    } catch (e) {
      throw Exception('Gagal menjalankan seeding katalog: $e');
    }
  }
}
