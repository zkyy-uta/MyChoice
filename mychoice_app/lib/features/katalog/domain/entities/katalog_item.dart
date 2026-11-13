/// Entitas domain untuk item katalog / barang (tabel pilihan_katalog di Supabase).
class KatalogItem {
  const KatalogItem({
    required this.id,
    required this.idSubKategori,
    required this.namaSubKategori,
    required this.namaKategori,
    required this.namaPilihan,
    this.harga,
    this.spesifikasi,
    this.rating,
  });

  final String id; // id_pilihan_katalog
  final int idSubKategori;
  final String namaSubKategori;
  final String namaKategori;
  final String namaPilihan;
  final double? harga;
  final String? spesifikasi;
  final double? rating;

  factory KatalogItem.fromMap(Map<String, dynamic> m) {
    return KatalogItem(
      id: m['id_pilihan_katalog'] as String,
      idSubKategori: (m['id_sub_kategori'] as num).toInt(),
      namaSubKategori: (m['nama_sub_kategori'] ?? '') as String,
      namaKategori: (m['nama_kategori'] ?? '') as String,
      namaPilihan: m['nama_pilihan'] as String,
      harga: m['harga'] == null ? null : (m['harga'] as num).toDouble(),
      spesifikasi: m['spesifikasi'] as String?,
      rating: m['rating'] == null ? null : (m['rating'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'KatalogItem($namaPilihan [$namaSubKategori / $namaKategori])';
}
