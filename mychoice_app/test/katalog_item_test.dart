import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/katalog/domain/entities/katalog_item.dart';

void main() {
  group('KatalogItem.fromMap', () {
    test('maps structured attributes and source metadata', () {
      final item = KatalogItem.fromMap({
        'id_pilihan_katalog': 'item-1',
        'id_sub_kategori': 7,
        'nama_sub_kategori': 'Laptop',
        'nama_kategori': 'Technology',
        'nama_pilihan': 'Sample laptop',
        'harga': 15000000,
        'spesifikasi': 'RAM: 16GB',
        'rating': 4.5,
        'atribut': {'ram': '16GB', 'storage': '512GB SSD'},
        'mata_uang': 'IDR',
        'sumber_url': 'https://example.com/item',
        'lisensi_data': 'CC-BY-4.0',
      });

      expect(item.atribut, {'ram': '16GB', 'storage': '512GB SSD'});
      expect(item.mataUang, 'IDR');
      expect(item.sumberUrl, 'https://example.com/item');
      expect(item.lisensiData, 'CC-BY-4.0');
    });

    test('keeps legacy rows compatible when new fields are absent', () {
      final item = KatalogItem.fromMap({
        'id_pilihan_katalog': 'item-2',
        'id_sub_kategori': 1,
        'nama_pilihan': 'Legacy item',
      });

      expect(item.atribut, isEmpty);
      expect(item.mataUang, isNull);
      expect(item.sumberUrl, isNull);
      expect(item.lisensiData, isNull);
    });
  });
}
