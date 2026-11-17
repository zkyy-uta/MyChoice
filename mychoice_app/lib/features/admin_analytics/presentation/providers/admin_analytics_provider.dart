import 'package:flutter/foundation.dart';

import '../../domain/entities/admin_review.dart';
import '../../domain/repositories/admin_analytics_repository.dart';

class AdminAnalyticsProvider extends ChangeNotifier {
  AdminAnalyticsProvider(this._repository);

  final AdminAnalyticsRepository _repository;

  List<AdminReview> _reviews = [];
  bool _isLoading = false;
  String? _error;

  List<AdminReview> get reviews => List.unmodifiable(_reviews);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReviews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _reviews = await _repository.getReviews();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
