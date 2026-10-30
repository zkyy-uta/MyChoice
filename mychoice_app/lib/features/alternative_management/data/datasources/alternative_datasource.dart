import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../alternative_management/domain/entities/alternative.dart';

/// Mock data source for alternatives
class MockAlternativeDataSource {
  /// Load alternatives from assets or return mock data
  Future<List<Alternative>> getCatalogAlternatives(String subcategoryId) async {
    try {
      // Try to load from assets
      final jsonString = await rootBundle.loadString(
        'assets/data/alternatives_catalog.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final alternatives = jsonData['alternatives'] as Map<String, dynamic>?;

      if (alternatives != null && alternatives.containsKey(subcategoryId)) {
        final list = alternatives[subcategoryId] as List<dynamic>;
        return list
            .map(
              (item) => Alternative(
                id: item['id'] as String? ?? '',
                name: item['name'] as String? ?? '',
                source: 'catalog',
                catalogId: item['id'] as String? ?? '',
                specs: item['specs'] as Map<String, dynamic>? ?? {},
              ),
            )
            .toList();
      }
    } catch (e) {
      // Fallback to mock data if file not found
      print('Error loading alternatives: $e, using mock data');
    }

    // Return mock data based on subcategory
    return _getMockAlternatives(subcategoryId);
  }

  /// Get mock alternatives based on subcategory
  List<Alternative> _getMockAlternatives(String subcategoryId) {
    final mockData = {
      'laptop': [
        Alternative(
          id: 'laptop_1',
          name: 'Apple MacBook Pro 16"',
          source: 'catalog',
          catalogId: 'laptop_1',
          specs: {
            'processor': 'Apple M3 Max',
            'ram': '36GB',
            'storage': '512GB SSD',
            'price': '\$3,499',
            'weight': '2.1 kg',
            'battery': '18 hours',
          },
        ),
        Alternative(
          id: 'laptop_2',
          name: 'Dell XPS 15',
          source: 'catalog',
          catalogId: 'laptop_2',
          specs: {
            'processor': 'Intel i9-13900HX',
            'ram': '32GB',
            'storage': '1TB SSD',
            'price': '\$2,499',
            'weight': '2.0 kg',
            'battery': '12 hours',
          },
        ),
        Alternative(
          id: 'laptop_3',
          name: 'Lenovo ThinkPad X1 Carbon',
          source: 'catalog',
          catalogId: 'laptop_3',
          specs: {
            'processor': 'Intel i7-1365U',
            'ram': '16GB',
            'storage': '512GB SSD',
            'price': '\$1,499',
            'weight': '1.29 kg',
            'battery': '16 hours',
          },
        ),
        Alternative(
          id: 'laptop_4',
          name: 'ASUS ROG Zephyrus G14',
          source: 'catalog',
          catalogId: 'laptop_4',
          specs: {
            'processor': 'AMD Ryzen 9 7950X3D',
            'ram': '32GB',
            'storage': '1TB SSD',
            'price': '\$1,999',
            'weight': '1.6 kg',
            'battery': '10 hours',
          },
        ),
        Alternative(
          id: 'laptop_5',
          name: 'HP Spectre x360 16',
          source: 'catalog',
          catalogId: 'laptop_5',
          specs: {
            'processor': 'Intel i7-13700H',
            'ram': '32GB',
            'storage': '512GB SSD',
            'price': '\$1,899',
            'weight': '2.0 kg',
            'battery': '14 hours',
          },
        ),
        Alternative(
          id: 'laptop_6',
          name: 'Microsoft Surface Laptop 5',
          source: 'catalog',
          catalogId: 'laptop_6',
          specs: {
            'processor': 'Intel i7-1285U',
            'ram': '16GB',
            'storage': '512GB SSD',
            'price': '\$1,499',
            'weight': '1.29 kg',
            'battery': '17 hours',
          },
        ),
      ],
      'smartphone': [
        Alternative(
          id: 'phone_1',
          name: 'iPhone 15 Pro Max',
          source: 'catalog',
          catalogId: 'phone_1',
          specs: {
            'processor': 'Apple A17 Pro',
            'ram': '8GB',
            'storage': '256GB',
            'price': '\$1,199',
            'display': '6.7" Super Retina XDR',
            'battery': '4,685 mAh',
          },
        ),
        Alternative(
          id: 'phone_2',
          name: 'Samsung Galaxy S24 Ultra',
          source: 'catalog',
          catalogId: 'phone_2',
          specs: {
            'processor': 'Snapdragon 8 Gen 3',
            'ram': '12GB',
            'storage': '256GB',
            'price': '\$1,299',
            'display': '6.8" Dynamic AMOLED 2X',
            'battery': '5,000 mAh',
          },
        ),
        Alternative(
          id: 'phone_3',
          name: 'Google Pixel 8 Pro',
          source: 'catalog',
          catalogId: 'phone_3',
          specs: {
            'processor': 'Google Tensor G3',
            'ram': '12GB',
            'storage': '256GB',
            'price': '\$999',
            'display': '6.7" QHD AMOLED',
            'battery': '5,050 mAh',
          },
        ),
        Alternative(
          id: 'phone_4',
          name: 'OnePlus 12',
          source: 'catalog',
          catalogId: 'phone_4',
          specs: {
            'processor': 'Snapdragon 8 Gen 3',
            'ram': '12GB',
            'storage': '256GB',
            'price': '\$799',
            'display': '6.7" Fluid AMOLED',
            'battery': '5,400 mAh',
          },
        ),
      ],
      'course': [
        Alternative(
          id: 'course_1',
          name: 'Udemy - Complete Flutter Development',
          source: 'catalog',
          catalogId: 'course_1',
          specs: {
            'duration': '50 hours',
            'price': '\$14.99',
            'students': '500K+',
            'rating': '4.8/5',
            'level': 'Beginner to Advanced',
          },
        ),
        Alternative(
          id: 'course_2',
          name: 'Google Flutter & Dart Mastery',
          source: 'catalog',
          catalogId: 'course_2',
          specs: {
            'duration': '40 hours',
            'price': '\$12.99',
            'students': '300K+',
            'rating': '4.7/5',
            'level': 'Intermediate',
          },
        ),
      ],
    };

    return mockData[subcategoryId] ?? [];
  }
}
