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
      final sub = m['subcategories'] as Map?;
      final namaSubKategori = sub?['nama_sub_kategori'] as String?;
      final kategori = sub?['categories'] as Map?;
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
      var query = _client.from('catalog_options').select('''
            id_pilihan_katalog,
            id_sub_kategori,
            nama_pilihan,
            harga,
            spesifikasi,
            rating,
            atribut,
            mata_uang,
            sumber_url,
            lisensi_data,
            subcategories!inner(nama_sub_kategori, categories!inner(nama_kategori))
          ''');

      if (kategori != null && kategori.isNotEmpty) {
        query = query.eq('subcategories.categories.nama_kategori', kategori);
      }
      if (subKategori != null && subKategori.isNotEmpty) {
        query = query.eq('subcategories.nama_sub_kategori', subKategori);
      }

      final response = await query.order('nama_pilihan');
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
          .from('catalog_options')
          .select('''
            id_pilihan_katalog,
            id_sub_kategori,
            nama_pilihan,
            harga,
            spesifikasi,
            rating,
            atribut,
            mata_uang,
            sumber_url,
            lisensi_data,
            subcategories!inner(nama_sub_kategori, categories!inner(nama_kategori))
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
      final response = await _client.functions.invoke(
        'seed-catalog',
        body: {
          'kategori': kategori,
          'sub_kategori': subKategori,
          'pilihan_katalog': pilihanKatalog,
          'reseed': true,
        },
      );
      final body = response.data;
      if (body is! Map || body['detail'] is! Map) {
        throw const FormatException('Respons seeding katalog tidak valid.');
      }

      final detail = body['detail'] as Map;
      final result = <String, int>{};
      for (final entry in detail.entries) {
        if (entry.key is! String || entry.value is! num) {
          throw const FormatException(
            'Detail respons seeding katalog tidak valid.',
          );
        }
        result[entry.key as String] = (entry.value as num).toInt();
      }
      return result;
    } catch (e) {
      throw Exception('Gagal menjalankan seeding katalog: $e');
    }
  }
}
