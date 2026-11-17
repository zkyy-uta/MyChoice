abstract class PersonalCriteriaRepository {
  Future<List<String>> getMyCriteria({
    required String category,
    required String subcategory,
  });

  Future<String> addMyCriterion({
    required String category,
    required String subcategory,
    required String name,
  });
}
