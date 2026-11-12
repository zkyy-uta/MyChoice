import '../entities/keputusan.dart';

abstract class KeputusanRepository {
  /// Simpan keputusan baru ke tabel keputusan.
  /// Melakukan lookup id_sub_kategori berdasarkan nama kategori & subkategori.
  Future<Keputusan> createKeputusan({
    required String namaKategori,
    required String namaSubkategori,
    required String judul,
    String status,
    String? decisionHistoryId,
  });

  /// Ambil semua keputusan milik user yang login.
  Future<List<Keputusan>> getKeputusanList();

  /// Update status keputusan.
  Future<void> updateStatus({
    required String idKeputusan,
    required String status,
  });

  /// Hapus keputusan.
  Future<void> deleteKeputusan(String idKeputusan);
}
