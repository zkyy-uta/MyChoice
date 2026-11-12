import 'package:flutter/foundation.dart';

import '../../domain/entities/keputusan.dart';
import '../../domain/repositories/keputusan_repository.dart';

/// Provider untuk mengelola state keputusan pengguna.
class KeputusanProvider extends ChangeNotifier {
  KeputusanProvider({required KeputusanRepository repository})
    : _repository = repository;

  final KeputusanRepository _repository;

  List<Keputusan> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Keputusan> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  /// Simpan keputusan baru ke tabel keputusan.
  /// Mengembalikan entitas yang dibuat, atau null jika gagal.
  Future<Keputusan?> addKeputusan({
    required String namaKategori,
    required String namaSubkategori,
    required String judul,
    String status = 'selesai',
    String? decisionHistoryId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final created = await _repository.createKeputusan(
        namaKategori: namaKategori,
        namaSubkategori: namaSubkategori,
        judul: judul,
        status: status,
        decisionHistoryId: decisionHistoryId,
      );
      _list.insert(0, created);
      notifyListeners();
      return created;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Muat semua keputusan milik user.
  Future<void> loadKeputusan() async {
    _setLoading(true);
    _setError(null);
    try {
      _list = await _repository.getKeputusanList();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Update status keputusan.
  Future<bool> updateStatus({
    required String idKeputusan,
    required String status,
  }) async {
    _setError(null);
    try {
      await _repository.updateStatus(idKeputusan: idKeputusan, status: status);
      final idx = _list.indexWhere((k) => k.idKeputusan == idKeputusan);
      if (idx != -1) {
        final old = _list[idx];
        _list[idx] = Keputusan(
          idKeputusan: old.idKeputusan,
          idPengguna: old.idPengguna,
          idSubKategori: old.idSubKategori,
          judul: old.judul,
          status: status,
          tanggalDibuat: old.tanggalDibuat,
          decisionHistoryId: old.decisionHistoryId,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Hapus keputusan.
  Future<bool> deleteKeputusan(String idKeputusan) async {
    _setError(null);
    try {
      await _repository.deleteKeputusan(idKeputusan);
      _list.removeWhere((k) => k.idKeputusan == idKeputusan);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
