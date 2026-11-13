import '../entities/katalog_item.dart';

/// Kontrak akses data katalog / barang (publik, tidak milik user tertentu).
abstract class KatalogRepository {
  /// Semua barang katalog, dengan opsi filter per kategori dan/atau subkategori.
  Future<List<KatalogItem>> getKatalog({String? kategori, String? subKategori});

  /// Barang dalam satu subkategori.
  Future<List<KatalogItem>> getBySubKategori(String namaSubKategori);

  /// Detail satu barang berdasarkan id_pilihan_katalog.
  Future<KatalogItem?> getById(String idPilihanKatalog);

  /// Panggil edge function `seed-catalog` untuk (re)seed data katalog.
  /// Hanya bisa dipanggil admin (dikelola di edge function).
  Future<Map<String, int>> reseedKatalog({
    required List<Map<String, dynamic>> kategori,
    required List<Map<String, dynamic>> subKategori,
    required List<Map<String, dynamic>> pilihanKatalog,
  });
}
