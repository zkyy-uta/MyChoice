import '../entities/alternative.dart';

abstract class PersonalAlternativeRepository {
  Future<List<Alternative>> getMyOptions({
    required String category,
    required String subcategory,
  });

  Future<Alternative> addMyOption({
    required String category,
    required String subcategory,
    required String name,
    required Map<String, dynamic> attributes,
  });

  Future<Alternative> updateMyOption({
    required String id,
    required String name,
    required Map<String, dynamic> attributes,
  });

  Future<void> deleteMyOption({required String id});
}
