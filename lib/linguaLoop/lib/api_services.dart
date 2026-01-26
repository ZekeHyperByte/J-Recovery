import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Untuk Android emulator
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers for API requests
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      print('🌐 API Call: $baseUrl$endpoint');
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      print('📡 Response: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Network Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('🌐 API Call: $baseUrl$endpoint');
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      print('📡 Response: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ Network Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('🎯 Handling response: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final dynamic decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is List) {
          return {'data': decoded, 'status': 'success'};
        } else {
          return {'status': 'success', 'data': decoded};
        }
      } catch (e) {
        print('❌ JSON Decode Error: $e');
        return {'status': 'error', 'message': 'Invalid JSON format'};
      }
    } else {
      print('❌ API Error: ${response.statusCode} - ${response.body}');
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Helper method untuk parsing tanggal dengan aman
  DateTime? _safeParseDate(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      if (dateValue is String) {
        // Coba parse sebagai DateTime langsung
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          // Jika gagal, coba format yang mungkin
          if (dateValue.contains('/')) {
            // Format: DD/MM/YYYY
            final parts = dateValue.split('/');
            if (parts.length == 3) {
              return DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );
            }
          }

          // Coba format timestamp
          final timestamp = int.tryParse(dateValue);
          if (timestamp != null) {
            return DateTime.fromMillisecondsSinceEpoch(timestamp);
          }

          return null;
        }
      } else if (dateValue is int) {
        // Timestamp dalam milidetik
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('⚠️ Date parsing error: $e for value: $dateValue');
    }

    return null;
  }

  // Format tanggal ke string yang konsisten
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // API Endpoints

  // Get latest statistics for home dashboard
  Future<Map<String, dynamic>> getLatestStatistics() async {
    return await get('/statistik/terbaru');
  }

  // Get all statistics
  Future<Map<String, dynamic>> getAllStatistics() async {
    return await get('/statistik');
  }

  // Get statistics by category
  Future<Map<String, dynamic>> getStatisticsByCategory(String category) async {
    return await get('/statistik?kategori=$category');
  }

  // Get recent publications - FIXED DATE FORMAT
  Future<List<Map<String, dynamic>>> getRecentPublications() async {
    try {
      final response = await get('/publikasi/recent');

      if (response['status'] == 'success' && response['data'] is List) {
        final publications = response['data'] as List;
        return publications.whereType<Map<String, dynamic>>().map((pub) {
          return _convertPublicationFields(pub);
        }).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error getting recent publications: $e');
      return [];
    }
  }

  // Get all publications with pagination - FIXED DATE FORMAT
  Future<List<Map<String, dynamic>>> getAllPublications({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await get('/publikasi?page=$page&limit=$limit');

      if (response['status'] == 'success' && response['data'] is List) {
        final publications = response['data'] as List;
        return publications.whereType<Map<String, dynamic>>().map((pub) {
          return _convertPublicationFields(pub);
        }).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error getting all publications: $e');
      return [];
    }
  }

  // Helper method to convert publication fields to correct types
  Map<String, dynamic> _convertPublicationFields(
      Map<String, dynamic> publication) {
    final publishDate = _safeParseDate(publication['publish_date']);

    return {
      'id': publication['id']?.toString() ?? '',
      'title': publication['title']?.toString() ?? 'No Title',
      'description': publication['description']?.toString() ?? '',
      'category': publication['category']?.toString() ?? 'General',
      'publish_date': _formatDate(publishDate),
      'author': publication['author']?.toString() ?? 'Unknown',
      'thumbnail': publication['thumbnail']?.toString() ?? '',
      'file_url': publication['file_url']?.toString() ?? '',
      'views': (publication['views'] is int) ? publication['views'] : 0,
      'downloads':
          (publication['downloads'] is int) ? publication['downloads'] : 0,
      'is_valid_date': publishDate != null,
    };
  }

  // Get publication categories
  Future<List<String>> getPublicationCategories() async {
    try {
      final response = await get('/publikasi/kategori');

      if (response['status'] == 'success' && response['data'] is List) {
        final categories = response['data'] as List;
        return categories
            .whereType<String>()
            .where((category) => category.isNotEmpty)
            .toList();
      }

      // Fallback categories
      return ['Ekonomi', 'Sosial', 'Pendidikan', 'Kesehatan', 'Demografi'];
    } catch (e) {
      print('❌ Error getting publication categories: $e');
      return ['Ekonomi', 'Sosial', 'Pendidikan', 'Kesehatan', 'Demografi'];
    }
  }

  // Get data categories
  Future<List<dynamic>> getDataCategories(String categoryType) async {
    try {
      final response = await get('/kategori?type=$categoryType');
      return (response['data'] is List) ? response['data'] : [];
    } catch (e) {
      print('❌ Error getting data categories: $e');
      return [];
    }
  }

  // Search data
  Future<List<dynamic>> searchData(String query) async {
    try {
      final response =
          await get('/data/search?query=${Uri.encodeComponent(query)}');
      return (response['data'] is List) ? response['data'] : [];
    } catch (e) {
      print('❌ Error searching data: $e');
      return [];
    }
  }

  // Get data detail
  Future<Map<String, dynamic>> getDataDetail(String dataId,
      {String? tahun, String? provinsi}) async {
    try {
      String endpoint = '/data/$dataId';
      final List<String> params = [];

      if (tahun != null && tahun.isNotEmpty) {
        params.add('tahun=${Uri.encodeComponent(tahun)}');
      }
      if (provinsi != null && provinsi.isNotEmpty) {
        params.add('provinsi=${Uri.encodeComponent(provinsi)}');
      }

      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }

      return await get(endpoint);
    } catch (e) {
      print('❌ Error getting data detail: $e');
      return {'error': 'Failed to load data: $e'};
    }
  }

  // Get population data
  Future<Map<String, dynamic>> getPopulationData(
      {String? tahun, String? provinsi}) async {
    return await getDataDetail('jumlah-penduduk',
        tahun: tahun, provinsi: provinsi);
  }

  // Get poverty data
  Future<Map<String, dynamic>> getPovertyData(
      {String? tahun, String? provinsi}) async {
    return await getDataDetail('penduduk-miskin',
        tahun: tahun, provinsi: provinsi);
  }

  // Get population density data
  Future<Map<String, dynamic>> getPopulationDensityData(
      {String? tahun, String? provinsi}) async {
    return await getDataDetail('kepadatan-penduduk',
        tahun: tahun, provinsi: provinsi);
  }

  // Get provinces/regions list
  Future<List<dynamic>> getProvinces() async {
    try {
      final response = await get('/wilayah/provinsi');
      return (response['data'] is List) ? response['data'] : [];
    } catch (e) {
      print('❌ Error getting provinces: $e');
      return [];
    }
  }

  // Get districts by province
  Future<List<dynamic>> getDistricts(String provinsiId) async {
    try {
      final response = await get('/wilayah/kabupaten?provinsi=$provinsiId');
      return (response['data'] is List) ? response['data'] : [];
    } catch (e) {
      print('❌ Error getting districts: $e');
      return [];
    }
  }

  // Get map data for specific region
  Future<Map<String, dynamic>> getMapData(String wilayahId) async {
    try {
      return await get('/data/peta?wilayah=$wilayahId');
    } catch (e) {
      print('❌ Error getting map data: $e');
      return {'error': 'Failed to load map data: $e'};
    }
  }

  // Get infographics
  Future<List<dynamic>> getInfographics() async {
    try {
      final response = await get('/infografis');
      return (response['data'] is List) ? response['data'] : [];
    } catch (e) {
      print('❌ Error getting infographics: $e');
      return [];
    }
  }

  // Get years available for specific data
  Future<List<String>> getAvailableYears(String dataId) async {
    try {
      final response = await get('/data/$dataId/tahun');

      if (response['status'] == 'success' && response['data'] is List) {
        final years = response['data'] as List;
        return years
            .map((year) => year?.toString() ?? '')
            .where((year) => year.isNotEmpty)
            .toList();
      }

      // Return default years if API fails
      return ['2020', '2021', '2022'];
    } catch (e) {
      print('❌ Error getting available years: $e');
      return ['2020', '2021', '2022'];
    }
  }

  // Health check
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/health'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Server returned ${response.statusCode}'
        };
      }
    } catch (e) {
      print('❌ Health check failed: $e');
      return {'status': 'error', 'message': 'Server unavailable: $e'};
    }
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}
