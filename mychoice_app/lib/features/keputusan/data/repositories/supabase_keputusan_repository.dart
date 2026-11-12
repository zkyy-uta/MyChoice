import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/keputusan.dart';
import '../../domain/repositories/keputusan_repository.dart';

/// Implementasi repository keputusan menggunakan Supabase.
class SupabaseKeputusanRepository implements KeputusanRepository {
  SupabaseKeputusanRepository(this._client);

  final SupabaseClient _client;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login.');
    return user.id;
  }

  /// Cari id_sub_kategori berdasarkan nama kategori + nama subkategori.
  /// Jika tidak ditemukan, kembalikan null (jangan throw agar tidak block save).
  Future<int?> _lookupSubKategoriId({
    required String namaKategori,
    required String namaSubkategori,
  }) async {
    try {
      final result = await _client
          .from('sub_kategori')
          .select('id_sub_kategori, kategori!inner(nama_kategori)')
          .eq('nama_sub_kategori', namaSubkategori)
          .eq('kategori.nama_kategori', namaKategori)
          .maybeSingle();

      if (result == null) return null;
      return (result['id_sub_kategori'] as num).toInt();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Keputusan> createKeputusan({
    required String namaKategori,
    required String namaSubkategori,
    required String judul,
    String status = 'selesai',
    String? decisionHistoryId,
  }) async {
    final userId = _currentUserId;

    // Lookup id_sub_kategori
    final idSubKategori = await _lookupSubKategoriId(
      namaKategori: namaKategori,
      namaSubkategori: namaSubkategori,
    );

    if (idSubKategori == null) {
      throw Exception(
        'Subkategori "$namaSubkategori" di kategori "$namaKategori" '
        'tidak ditemukan. Pastikan seed data sudah dijalankan di Supabase.',
      );
    }

    try {
      final payload = <String, dynamic>{
        'id_pengguna': userId,
        'id_sub_kategori': idSubKategori,
        'judul': judul,
        'status': status,
      };

      final response = await _client
          .from('keputusan')
          .insert(payload)
          .select()
          .single();

      return Keputusan(
        idKeputusan: response['id_keputusan'] as String,
        idPengguna: response['id_pengguna'] as String,
        idSubKategori: (response['id_sub_kategori'] as num).toInt(),
        judul: response['judul'] as String,
        status: response['status'] as String,
        tanggalDibuat: DateTime.parse(response['tanggal_dibuat'] as String),
        decisionHistoryId: decisionHistoryId,
      );
    } on PostgrestException catch (e) {
      throw Exception('Gagal menyimpan keputusan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menyimpan keputusan: $e');
    }
  }

  @override
  Future<List<Keputusan>> getKeputusanList() async {
    final userId = _currentUserId;

    try {
      final response = await _client
          .from('keputusan')
          .select()
          .eq('id_pengguna', userId)
          .order('tanggal_dibuat', ascending: false);

      return (response as List<dynamic>).map((row) {
        final r = row as Map<String, dynamic>;
        return Keputusan(
          idKeputusan: r['id_keputusan'] as String,
          idPengguna: r['id_pengguna'] as String,
          idSubKategori: (r['id_sub_kategori'] as num).toInt(),
          judul: r['judul'] as String,
          status: r['status'] as String,
          tanggalDibuat: DateTime.parse(r['tanggal_dibuat'] as String),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal memuat daftar keputusan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal memuat daftar keputusan: $e');
    }
  }

  @override
  Future<void> updateStatus({
    required String idKeputusan,
    required String status,
  }) async {
    final userId = _currentUserId;

    try {
      await _client
          .from('keputusan')
          .update({'status': status})
          .eq('id_keputusan', idKeputusan)
          .eq('id_pengguna', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal update status keputusan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal update status keputusan: $e');
    }
  }

  @override
  Future<void> deleteKeputusan(String idKeputusan) async {
    final userId = _currentUserId;

    try {
      await _client
          .from('keputusan')
          .delete()
          .eq('id_keputusan', idKeputusan)
          .eq('id_pengguna', userId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus keputusan: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus keputusan: $e');
    }
  }
}
