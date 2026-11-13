import 'package:flutter/foundation.dart';

import '../../domain/entities/katalog_item.dart';
import '../../domain/repositories/katalog_repository.dart';

/// State manajemen katalog / barang untuk layar publik & admin.
class KatalogProvider extends ChangeNotifier {
  KatalogProvider(this._repository);

  final KatalogRepository _repository;

  List<KatalogItem> _items = [];
  List<KatalogItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Muat semua katalog, opsi filter kategori / subkategori.
  Future<void> loadKatalog({String? kategori, String? subKategori}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getKatalog(
        kategori: kategori,
        subKategori: subKategori,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Muat barang dalam satu subkategori.
  Future<void> loadBySubKategori(String namaSubKategori) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getBySubKategori(namaSubKategori);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Jalankan (re)seed lewat edge function (hanya admin).
  Future<Map<String, int>> reseedKatalog({
    required List<Map<String, dynamic>> kategori,
    required List<Map<String, dynamic>> subKategori,
    required List<Map<String, dynamic>> pilihanKatalog,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.reseedKatalog(
        kategori: kategori,
        subKategori: subKategori,
        pilihanKatalog: pilihanKatalog,
      );
      _error = null;
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
