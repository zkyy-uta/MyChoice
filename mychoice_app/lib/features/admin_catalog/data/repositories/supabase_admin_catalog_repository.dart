import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../category_selection/data/datasources/supabase_subcategory_lookup.dart';
import '../../domain/entities/admin_catalog_data.dart';
import '../../domain/repositories/admin_catalog_repository.dart';

class SupabaseAdminCatalogRepository implements AdminCatalogRepository {
  SupabaseAdminCatalogRepository(this._client);

  final SupabaseClient _client;

  Future<int> _subcategoryId(String category, String subcategory) =>
      SupabaseSubcategoryLookup.getId(
        _client,
        category: category,
        subcategory: subcategory,
      );

  @override
  Future<AdminSubcategoryCatalog> loadSubcategory({
    required String category,
    required String subcategory,
  }) async {
    final subcategoryId = await _subcategoryId(category, subcategory);
    try {
      final criteriaRows = await _client
          .from('kriteria')
          .select('id_kriteria,nama_kriteria,jenis_kriteria,satuan,atribut_key')
          .eq('id_sub_kategori', subcategoryId)
          .order('nama_kriteria');
      final optionRows = await _client
          .from('pilihan_katalog')
          .select('id_pilihan_katalog,nama_pilihan,atribut,harga')
          .eq('id_sub_kategori', subcategoryId)
          .order('nama_pilihan');

      final criteria = (criteriaRows as List<dynamic>).map((row) {
        final item = Map<String, dynamic>.from(row as Map);
        return AdminCatalogCriterion(
          id: (item['id_kriteria'] as num).toInt(),
          name: item['nama_kriteria'] as String,
          type: item['jenis_kriteria'] == 'cost' ? 'Cost' : 'Benefit',
          unit: item['satuan'] as String? ?? '',
          attributeKey: item['atribut_key'] as String?,
        );
      }).toList();
      final options = (optionRows as List<dynamic>).map((row) {
        final item = Map<String, dynamic>.from(row as Map);
        final attributes = item['atribut'];
        return AdminCatalogOption(
          id: item['id_pilihan_katalog'] as String,
          name: item['nama_pilihan'] as String,
          attributes: attributes is Map
              ? Map<String, dynamic>.from(attributes)
              : const {},
          price: (item['harga'] as num?)?.toDouble(),
        );
      }).toList();
      return AdminSubcategoryCatalog(criteria: criteria, options: options);
    } on PostgrestException catch (error) {
      throw Exception(
        'Failed to load the subcategory catalog: ${error.message}',
      );
    }
  }

  @override
  Future<AdminCatalogCriterion> addCriterion({
    required String category,
    required String subcategory,
    required String name,
    required String type,
    required String unit,
  }) async {
    final subcategoryId = await _subcategoryId(category, subcategory);
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || normalizedName.length > 150) {
      throw ArgumentError('Criterion name must contain 1 to 150 characters.');
    }

    try {
      final attributeKey = _attributeKey(normalizedName);
      final row = await _client
          .from('kriteria')
          .insert({
            'id_sub_kategori': subcategoryId,
            'nama_kriteria': normalizedName,
            'jenis_kriteria': type.toLowerCase(),
            'satuan': unit.trim().isEmpty ? null : unit.trim(),
            'atribut_key': attributeKey,
          })
          .select('id_kriteria,nama_kriteria,jenis_kriteria,satuan,atribut_key')
          .single();
      final item = Map<String, dynamic>.from(row);
      return AdminCatalogCriterion(
        id: (item['id_kriteria'] as num).toInt(),
        name: item['nama_kriteria'] as String,
        type: item['jenis_kriteria'] == 'cost' ? 'Cost' : 'Benefit',
        unit: item['satuan'] as String? ?? '',
        attributeKey: item['atribut_key'] as String?,
      );
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw StateError('This criterion already exists in this subcategory.');
      }
      throw Exception('Failed to save the criterion: ${error.message}');
    }
  }

  @override
  Future<String> saveOption({
    required String category,
    required String subcategory,
    String? id,
    required String name,
    required Map<String, String> values,
    required Set<String> unavailable,
    required List<AdminCatalogCriterion> criteria,
  }) async {
    final subcategoryId = await _subcategoryId(category, subcategory);
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || normalizedName.length > 200) {
      throw ArgumentError('Option name must contain 1 to 200 characters.');
    }

    final attributes = <String, dynamic>{};
    final specifications = <String>[];
    double? price;
    String? currency;
    double? rating;
    for (final criterion in criteria) {
      final value = values[criterion.name]?.trim() ?? '';
      if (unavailable.contains(criterion.name)) {
        attributes[criterion.attributeKey ?? _attributeKey(criterion.name)] =
            'N/A';
        specifications.add('${criterion.name}: N/A');
        continue;
      }
      if (value.isEmpty) continue;

      final key = criterion.attributeKey ?? _attributeKey(criterion.name);
      if (key == 'harga' || criterion.name.toLowerCase() == 'price') {
        final parsed = double.tryParse(
          value.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (parsed != null) {
          price = parsed;
          currency = criterion.unit.toLowerCase().contains('rp') ? 'IDR' : null;
        }
        attributes[key] = value;
      } else {
        attributes[key] = value;
        if (criterion.name.toLowerCase() == 'rating') {
          rating = double.tryParse(value);
        }
      }
      specifications.add('${criterion.name}: $value');
    }

    try {
      if (id == null) {
        final payload = _optionPayload(
          subcategoryId: subcategoryId,
          name: normalizedName,
          price: price,
          rating: rating,
          specifications: specifications,
          attributes: attributes,
          currency: currency,
        );
        final row = await _client
            .from('pilihan_katalog')
            .insert(payload)
            .select('id_pilihan_katalog')
            .single();
        return row['id_pilihan_katalog'] as String;
      }

      final existingRow = await _client
          .from('pilihan_katalog')
          .select('atribut,harga,rating,mata_uang,spesifikasi')
          .eq('id_pilihan_katalog', id)
          .eq('id_sub_kategori', subcategoryId)
          .maybeSingle();
      if (existingRow == null) {
        throw StateError('The catalog option was not found.');
      }

      final existingAttributes = existingRow['atribut'];
      final mergedAttributes = existingAttributes is Map
          ? Map<String, dynamic>.from(existingAttributes)
          : <String, dynamic>{};
      mergedAttributes.addAll(attributes);

      final changedCriteria = criteria
          .where(
            (criterion) =>
                unavailable.contains(criterion.name) ||
                (values[criterion.name]?.trim().isNotEmpty ?? false),
          )
          .map((criterion) => criterion.name.toLowerCase())
          .toSet();
      final existingSpecifications =
          (existingRow['spesifikasi'] as String? ?? '')
              .split(';')
              .map((item) => item.trim())
              .where((item) {
                final separator = item.indexOf(':');
                if (separator <= 0) return item.isNotEmpty;
                final criterionName = item
                    .substring(0, separator)
                    .trim()
                    .toLowerCase();
                return !changedCriteria.contains(criterionName);
              });
      final priceWasMarkedUnavailable = criteria.any(
        (criterion) =>
            unavailable.contains(criterion.name) &&
            _attributeKey(criterion.name) == 'harga',
      );
      final ratingWasMarkedUnavailable = criteria.any(
        (criterion) =>
            unavailable.contains(criterion.name) &&
            criterion.name.toLowerCase() == 'rating',
      );
      final payload = _optionPayload(
        subcategoryId: subcategoryId,
        name: normalizedName,
        price: priceWasMarkedUnavailable
            ? null
            : price ?? (existingRow['harga'] as num?)?.toDouble(),
        rating: ratingWasMarkedUnavailable
            ? null
            : rating ?? (existingRow['rating'] as num?)?.toDouble(),
        specifications: [...existingSpecifications, ...specifications],
        attributes: mergedAttributes,
        currency: priceWasMarkedUnavailable
            ? null
            : price == null
            ? existingRow['mata_uang'] as String?
            : currency,
      );
      final row = await _client
          .from('pilihan_katalog')
          .update(payload)
          .eq('id_pilihan_katalog', id)
          .select('id_pilihan_katalog')
          .maybeSingle();
      if (row == null) {
        throw StateError('The catalog option was not found.');
      }
      return row['id_pilihan_katalog'] as String;
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        throw StateError('An option with this name already exists here.');
      }
      throw Exception('Failed to save the option: ${error.message}');
    }
  }

  Map<String, dynamic> _optionPayload({
    required int subcategoryId,
    required String name,
    required double? price,
    required double? rating,
    required Iterable<String> specifications,
    required Map<String, dynamic> attributes,
    required String? currency,
  }) => {
    'id_sub_kategori': subcategoryId,
    'nama_pilihan': name,
    'harga': price,
    'rating': rating,
    'spesifikasi': specifications.join('; '),
    'atribut': attributes,
    'mata_uang': currency,
  };

  @override
  Future<void> deleteOption({required String id}) async {
    try {
      final rows = await _client
          .from('pilihan_katalog')
          .delete()
          .eq('id_pilihan_katalog', id)
          .select('id_pilihan_katalog');
      if ((rows as List<dynamic>).isEmpty) {
        throw StateError('The catalog option was not found.');
      }
    } on PostgrestException catch (error) {
      throw Exception('Failed to delete the option: ${error.message}');
    }
  }

  String _attributeKey(String name) {
    if (name.trim().toLowerCase() == 'price') return 'harga';
    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }
}
