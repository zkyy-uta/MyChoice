/// Entitas domain untuk keputusan pengguna (tabel keputusan di Supabase ERD).
class Keputusan {
  const Keputusan({
    required this.idKeputusan,
    required this.idPengguna,
    required this.idSubKategori,
    required this.judul,
    required this.status,
    required this.tanggalDibuat,
    this.decisionHistoryId,
  });

  final String idKeputusan;
  final String idPengguna;
  final int idSubKategori;
  final String judul;
  final String status;
  final DateTime tanggalDibuat;

  /// ID di tabel decision_histories (untuk linking ke history screen)
  final String? decisionHistoryId;
}
