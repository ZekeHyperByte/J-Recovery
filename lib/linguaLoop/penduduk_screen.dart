import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SemarangData {
  final int year;
  final int? population;
  final double? area;
  final int? density;
  final int? districts;
  final int? villages;
  final int? malePopulation;
  final int? femalePopulation;
  final double? growthRate;

  // Cache formatted values to avoid repeated calculations
  late final String populationFormatted;
  late final String malePopulationFormatted;
  late final String femalePopulationFormatted;
  late final String densityFormatted;
  late final String populationInMillions;
  late final String malePopulationInMillions;
  late final String femalePopulationInMillions;
  late final double malePercentage;
  late final double femalePercentage;

  SemarangData({
    required this.year,
    this.population,
    this.area,
    this.density,
    this.districts,
    this.villages,
    this.malePopulation,
    this.femalePopulation,
    this.growthRate,
  }) {
    // Pre-calculate all formatted values once
    populationFormatted = population?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},') ?? 'N/A';
    malePopulationFormatted = malePopulation?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},') ?? 'N/A';
    femalePopulationFormatted = femalePopulation?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},') ?? 'N/A';
    densityFormatted = density?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.') ?? 'N/A';
    populationInMillions = population != null ? (population! / 1000000.0).toStringAsFixed(3) : 'N/A';
    malePopulationInMillions = malePopulation != null ? (malePopulation! / 1000000.0).toStringAsFixed(3) : 'N/A';
    femalePopulationInMillions = femalePopulation != null ? (femalePopulation! / 1000000.0).toStringAsFixed(3) : 'N/A';
    malePercentage = (population != null && malePopulation != null && population! > 0) 
        ? (malePopulation! / population! * 100) : 0.0;
    femalePercentage = (population != null && femalePopulation != null && population! > 0) 
        ? (femalePopulation! / population! * 100) : 0.0;
  }
}

class DistrictDensity {
  final String name;
  final int density;
  final double population;

  // Cache formatted values
  late final String densityFormatted;
  late final String populationFormatted;

  DistrictDensity({required this.name, required this.density, required this.population}) {
    densityFormatted = density.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
    populationFormatted = population.toStringAsFixed(2);
  }
}

class PendudukScreen extends StatefulWidget {
  const PendudukScreen({super.key});

  @override
  State<PendudukScreen> createState() => _PendudukScreenState();
}

class _PendudukScreenState extends State<PendudukScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  Map<int, SemarangData> semarangDataByYear = {};
  Map<int, List<DistrictDensity>> districtDensityByYear = {};
  List<int> availableYears = [];
  int selectedYear = 2024;
  bool isLoading = true;

  // Cache commonly used values
  List<FlSpot> _cachedSpots = [];
  Map<int, List<PieChartSectionData>> _cachedPieDataByYear = {};
  Map<int, Map<String, dynamic>> _ageDataByYear = {};
  List<Color> _districtColors = [];
  
  // Animation controller only for pie chart
  late AnimationController _pieChartAnimationController;
  late Animation<double> _pieChartAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    // Only pie chart animation controller
    _pieChartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _pieChartAnimation = CurvedAnimation(
      parent: _pieChartAnimationController,
      curve: Curves.easeInOut,
    );
    
    _initializeColors();
    _loadData();
  }

  @override
  void dispose() {
    _pieChartAnimationController.dispose();
    super.dispose();
  }

  void _initializeColors() {
    _districtColors = [
      const Color(0xFF8B4513),
      const Color(0xFF8B4513),
      const Color(0xFF8B4513),
      const Color(0xFF9E9E9E),
      const Color(0xFF9E9E9E),
    ];
  }

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedData = prefs.getString('penduduk_data');
      String? savedAgeData = prefs.getString('age_distribution_data');
      String? savedDistrictData = prefs.getString('district_density_data');
      
      Map<int, SemarangData> processedData;
      
      if (savedData != null) {
        // Load from SharedPreferences (data from admin)
        Map<String, dynamic> decoded = json.decode(savedData);
        processedData = {};
        
        decoded.forEach((key, value) {
          int year = int.parse(key);
          Map<String, dynamic> data = value as Map<String, dynamic>;
          processedData[year] = SemarangData(
            year: year,
            population: data['population'],
            malePopulation: data['malePopulation'],
            femalePopulation: data['femalePopulation'],
            area: data['area']?.toDouble(),
            density: data['density'],
            districts: data['districts'],
            villages: data['villages'],
            growthRate: data['growthRate']?.toDouble(),
          );
        });
      } else {
        // Default data if no admin data exists
        processedData = {
          2020: SemarangData(
            year: 2020,
            population: 1653524,
            malePopulation: 818441,
            femalePopulation: 835083,
            area: 373.7,
            density: 4425,
            districts: 16,
            villages: 177,
          ),
          2021: SemarangData(
            year: 2021,
            population: 1656564,
            malePopulation: 819785,
            femalePopulation: 836779,
            area: 374.0,
            density: 4433,
            districts: 16,
            villages: 177,
            growthRate: 0.18,
          ),
          2022: SemarangData(
            year: 2022,
            population: 1659975,
            malePopulation: 821305,
            femalePopulation: 838670,
            area: 374.0,
            density: 4442,
            districts: 16,
            villages: 177,
            growthRate: 0.21,
          ),
          2023: SemarangData(
            year: 2023,
            population: 1694743,
            malePopulation: 838437,
            femalePopulation: 856306,
            area: 374.0,
            density: 4535,
            districts: 16,
            villages: 177,
            growthRate: 2.09,
          ),
          2024: SemarangData(
            year: 2024,
            population: 1708833,
            malePopulation: 845177,
            femalePopulation: 863656,
            area: 374.0,
            density: 4573,
            districts: 16,
            villages: 177,
            growthRate: 0.83,
          ),
        };
      }

      // Calculate chart spots based on growth rates
      List<int> years = processedData.keys.toList()..sort();
      _cachedSpots = [];
      for (int i = 0; i < years.length; i++) {
        double growthRate = processedData[years[i]]?.growthRate ?? 0.0;
        _cachedSpots.add(FlSpot(i.toDouble(), growthRate / 100));
      }

      // Load age distribution data from admin or use default
      Map<int, Map<String, dynamic>> loadedAgeData;
      if (savedAgeData != null) {
        Map<String, dynamic> decoded = json.decode(savedAgeData);
        loadedAgeData = {};
        decoded.forEach((key, value) {
          loadedAgeData[int.parse(key)] = Map<String, dynamic>.from(value as Map);
        });
      } else {
        loadedAgeData = {
          2020: {
            'usiaMuda': 367018,
            'usiaMudaPercentage': 22.20,
            'usiaProduktif': 1182010,
            'usiaProduktifPercentage': 71.48,
            'usiaTua': 104496,
            'usiaTuaPercentage': 6.32,
          },
          2021: {
            'usiaMuda': 363757,
            'usiaMudaPercentage': 21.96,
            'usiaProduktif': 1182986,
            'usiaProduktifPercentage': 71.41,
            'usiaTua': 109821,
            'usiaTuaPercentage': 6.63,
          },
          2022: {
            'usiaMuda': 360777,
            'usiaMudaPercentage': 21.73,
            'usiaProduktif': 1183941,
            'usiaProduktifPercentage': 71.32,
            'usiaTua': 115257,
            'usiaTuaPercentage': 6.94,
          },
          2023: {
            'usiaMuda': 359130,
            'usiaMudaPercentage': 21.19,
            'usiaProduktif': 1207250,
            'usiaProduktifPercentage': 71.23,
            'usiaTua': 128400,
            'usiaTuaPercentage': 7.58,
          },
          2024: {
            'usiaMuda': 356758,
            'usiaMudaPercentage': 20.88,
            'usiaProduktif': 1214892,
            'usiaProduktifPercentage': 71.09,
            'usiaTua': 137183,
            'usiaTuaPercentage': 8.03,
          },
        };
      }

      // Update _ageDataByYear to match loaded data
      _ageDataByYear = loadedAgeData.map((year, ageData) {
        return MapEntry(year, {
          'usiaMuda': {'total': ageData['usiaMuda'], 'percentage': ageData['usiaMudaPercentage']},
          'usiaProduktif': {'total': ageData['usiaProduktif'], 'percentage': ageData['usiaProduktifPercentage']},
          'usiaTua': {'total': ageData['usiaTua'], 'percentage': ageData['usiaTuaPercentage']},
          'totalPopulation': ageData['usiaMuda'] + ageData['usiaProduktif'] + ageData['usiaTua'],
        });
      });

      // Re-calculate pie chart data for each year
      _cachedPieDataByYear = {};
      for (int year in _ageDataByYear.keys) {
        final ageData = _ageDataByYear[year]!;
        _cachedPieDataByYear[year] = [
          PieChartSectionData(
            color: Colors.blue[400]!,
            value: ageData['usiaMuda']['percentage'].toDouble(),
            title: '${ageData['usiaMuda']['percentage']}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.green[400]!,
            value: ageData['usiaProduktif']['percentage'].toDouble(),
            title: '${ageData['usiaProduktif']['percentage']}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.orange[400]!,
            value: ageData['usiaTua']['percentage'].toDouble(),
            title: '${ageData['usiaTua']['percentage']}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ];
      }

      // Load district data from admin or use default
      Map<int, List<DistrictDensity>> loadedDistrictData;
      if (savedDistrictData != null) {
        Map<String, dynamic> decoded = json.decode(savedDistrictData);
        loadedDistrictData = {};
        decoded.forEach((key, value) {
          int year = int.parse(key);
          List<dynamic> districts = value as List<dynamic>;
          loadedDistrictData[year] = districts.map((d) {
            Map<String, dynamic> district = d as Map<String, dynamic>;
            return DistrictDensity(
              name: district['name'],
              density: district['density'],
              population: district['population'].toDouble(),
            );
          }).toList();
        });
      } else {
        loadedDistrictData = {
          2020: [
            DistrictDensity(name: "Pedurungan", density: 9322, population: 193.151),
            DistrictDensity(name: "Tembalang", density: 4291, population: 189.680),
            DistrictDensity(name: "Semarang Barat", density: 6848, population: 148.879),
            DistrictDensity(name: "Banyumanik", density: 5530, population: 142.076),
            DistrictDensity(name: "Ngaliyan", density: 3731, population: 141.727),
          ],
          2021: [
            DistrictDensity(name: "Pedurungan", density: 9321, population: 193.128),
            DistrictDensity(name: "Tembalang", density: 4334, population: 191.560),
            DistrictDensity(name: "Semarang Barat", density: 6802, population: 147.885),
            DistrictDensity(name: "Ngaliyan", density: 3741, population: 142.131),
            DistrictDensity(name: "Banyumanik", density: 5515, population: 141.689),
          ],
          2022: [
            DistrictDensity(name: "Tembalang", density: 4377, population: 193.480),
            DistrictDensity(name: "Pedurungan", density: 9321, population: 193.125),
            DistrictDensity(name: "Semarang Barat", density: 6758, population: 146.915),
            DistrictDensity(name: "Ngaliyan", density: 3752, population: 142.553),
            DistrictDensity(name: "Banyumanik", density: 5501, population: 141.319),
          ],
          2023: [
            DistrictDensity(name: "Tembalang", density: 4499, population: 198.862),
            DistrictDensity(name: "Pedurungan", density: 9485, population: 196.526),
            DistrictDensity(name: "Semarang Barat", density: 6869, population: 149.326),
            DistrictDensity(name: "Ngaliyan", density: 3830, population: 145.495),
            DistrictDensity(name: "Banyumanik", density: 5583, population: 143.433),
          ],
          2024: [
            DistrictDensity(name: "Tembalang", density: 4566, population: 201.821),
            DistrictDensity(name: "Pedurungan", density: 9530, population: 197.468),
            DistrictDensity(name: "Semarang Barat", density: 6869, population: 149.327),
            DistrictDensity(name: "Ngaliyan", density: 3860, population: 146.628),
            DistrictDensity(name: "Banyumanik", density: 5595, population: 143.746),
          ],
        };
      }

      if (mounted) {
        setState(() {
          semarangDataByYear = processedData;
          districtDensityByYear = loadedDistrictData;
          availableYears = years;
          selectedYear = years.isNotEmpty ? years.last : 2024;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      // Load default data on error
      _loadDefaultData();
    }
  }

  void _loadDefaultData() {
    final processedData = <int, SemarangData>{
      2020: SemarangData(
        year: 2020,
        population: 1653524,
        malePopulation: 818441,
        femalePopulation: 835083,
        area: 373.7,
        density: 4425,
        districts: 16,
        villages: 177,
      ),
      2021: SemarangData(
        year: 2021,
        population: 1656564,
        malePopulation: 819785,
        femalePopulation: 836779,
        area: 374.0,
        density: 4433,
        districts: 16,
        villages: 177,
        growthRate: 0.18,
      ),
      2022: SemarangData(
        year: 2022,
        population: 1659975,
        malePopulation: 821305,
        femalePopulation: 838670,
        area: 374.0,
        density: 4442,
        districts: 16,
        villages: 177,
        growthRate: 0.21,
      ),
      2023: SemarangData(
        year: 2023,
        population: 1694743,
        malePopulation: 838437,
        femalePopulation: 856306,
        area: 374.0,
        density: 4535,
        districts: 16,
        villages: 177,
        growthRate: 2.09,
      ),
      2024: SemarangData(
        year: 2024,
        population: 1708833,
        malePopulation: 845177,
        femalePopulation: 863656,
        area: 374.0,
        density: 4573,
        districts: 16,
        villages: 177,
        growthRate: 0.83,
      ),
    };

    _cachedSpots = [
      const FlSpot(0, 0),
      const FlSpot(1, 0.0018),
      const FlSpot(2, 0.0021),
      const FlSpot(3, 0.0209),
      const FlSpot(4, 0.0083),
    ];

    _ageDataByYear = {
      2020: {
        'usiaMuda': {'total': 367018, 'percentage': 22.20},
        'usiaProduktif': {'total': 1182010, 'percentage': 71.48},
        'usiaTua': {'total': 104496, 'percentage': 6.32},
        'totalPopulation': 1653524,
      },
      2021: {
        'usiaMuda': {'total': 363757, 'percentage': 21.96},
        'usiaProduktif': {'total': 1182986, 'percentage': 71.41},
        'usiaTua': {'total': 109821, 'percentage': 6.63},
        'totalPopulation': 1656564,
      },
      2022: {
        'usiaMuda': {'total': 360777, 'percentage': 21.73},
        'usiaProduktif': {'total': 1183941, 'percentage': 71.32},
        'usiaTua': {'total': 115257, 'percentage': 6.94},
        'totalPopulation': 1659975,
      },
      2023: {
        'usiaMuda': {'total': 359130, 'percentage': 21.19},
        'usiaProduktif': {'total': 1207250, 'percentage': 71.23},
        'usiaTua': {'total': 128400, 'percentage': 7.58},
        'totalPopulation': 1694780,
      },
      2024: {
        'usiaMuda': {'total': 356758, 'percentage': 20.88},
        'usiaProduktif': {'total': 1214892, 'percentage': 71.09},
        'usiaTua': {'total': 137183, 'percentage': 8.03},
        'totalPopulation': 1708833,
      },
    };

    _cachedPieDataByYear = {};
    for (int year in _ageDataByYear.keys) {
      final ageData = _ageDataByYear[year]!;
      _cachedPieDataByYear[year] = [
        PieChartSectionData(
          color: Colors.blue[400]!,
          value: ageData['usiaMuda']['percentage'].toDouble(),
          title: '${ageData['usiaMuda']['percentage']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.green[400]!,
          value: ageData['usiaProduktif']['percentage'].toDouble(),
          title: '${ageData['usiaProduktif']['percentage']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.orange[400]!,
          value: ageData['usiaTua']['percentage'].toDouble(),
          title: '${ageData['usiaTua']['percentage']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    final districtData = <int, List<DistrictDensity>>{
      2020: [
        DistrictDensity(name: "Pedurungan", density: 9322, population: 193.151),
        DistrictDensity(name: "Tembalang", density: 4291, population: 189.680),
        DistrictDensity(name: "Semarang Barat", density: 6848, population: 148.879),
        DistrictDensity(name: "Banyumanik", density: 5530, population: 142.076),
        DistrictDensity(name: "Ngaliyan", density: 3731, population: 141.727),
      ],
      2021: [
        DistrictDensity(name: "Pedurungan", density: 9321, population: 193.128),
        DistrictDensity(name: "Tembalang", density: 4334, population: 191.560),
        DistrictDensity(name: "Semarang Barat", density: 6802, population: 147.885),
        DistrictDensity(name: "Ngaliyan", density: 3741, population: 142.131),
        DistrictDensity(name: "Banyumanik", density: 5515, population: 141.689),
      ],
      2022: [
        DistrictDensity(name: "Tembalang", density: 4377, population: 193.480),
        DistrictDensity(name: "Pedurungan", density: 9321, population: 193.125),
        DistrictDensity(name: "Semarang Barat", density: 6758, population: 146.915),
        DistrictDensity(name: "Ngaliyan", density: 3752, population: 142.553),
        DistrictDensity(name: "Banyumanik", density: 5501, population: 141.319),
      ],
      2023: [
        DistrictDensity(name: "Tembalang", density: 4499, population: 198.862),
        DistrictDensity(name: "Pedurungan", density: 9485, population: 196.526),
        DistrictDensity(name: "Semarang Barat", density: 6869, population: 149.326),
        DistrictDensity(name: "Ngaliyan", density: 3830, population: 145.495),
        DistrictDensity(name: "Banyumanik", density: 5583, population: 143.433),
      ],
      2024: [
        DistrictDensity(name: "Tembalang", density: 4566, population: 201.821),
        DistrictDensity(name: "Pedurungan", density: 9530, population: 197.468),
        DistrictDensity(name: "Semarang Barat", density: 6869, population: 149.327),
        DistrictDensity(name: "Ngaliyan", density: 3860, population: 146.628),
        DistrictDensity(name: "Banyumanik", density: 5595, population: 143.746),
      ],
    };

    if (mounted) {
      setState(() {
        semarangDataByYear = processedData;
        districtDensityByYear = districtData;
        availableYears = [2020, 2021, 2022, 2023, 2024];
        selectedYear = 2024;
        isLoading = false;
      });
    }
  }

  SemarangData get currentSemarangData {
    return semarangDataByYear[selectedYear] ?? semarangDataByYear[availableYears.last]!;
  }

  List<DistrictDensity> get currentDistrictDensity {
    return districtDensityByYear[selectedYear] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF5EE),
        appBar: AppBar(
          title: const Text('Penduduk Kota Semarang'),
          backgroundColor: const Color(0xFF795548),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF795548)),
              SizedBox(height: 16),
              Text('Memuat data...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 242, 250),
      appBar: AppBar(
        title: const Text('Penduduk Kota Semarang'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadData();
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 20),
          _buildYearSelector(),
          const SizedBox(height: 20),
          _buildPopulationStats(),
          const SizedBox(height: 20),
          _buildPopulationChart(),
          const SizedBox(height: 20),
          _buildAgeDistributionChart(),
          const SizedBox(height: 20),
          _buildAdministrativeData(),
          const SizedBox(height: 20),
          _buildDistrictDensitySection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAdministrativeData() {
    final data = currentSemarangData;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Administrasi Kota Semarang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.account_balance, color: Colors.purple[600], size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '${data.districts}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        Text(
                          'Kecamatan',
                          style: TextStyle(fontSize: 12, color: Colors.purple[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.teal[600], size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '${data.villages}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        Text(
                          'Kelurahan',
                          style: TextStyle(fontSize: 12, color: Colors.teal[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final data = currentSemarangData;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF795548), Color(0xFF8D6E63)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_city, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penduduk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Data kependudukan tahun ${data.year}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
              const SizedBox(width: 8),
              Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: availableYears.map((year) {
              final isSelected = year == selectedYear;
              return SizedBox(
                width: 63,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedYear = year;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 121, 85, 72) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color.fromARGB(255, 121, 85, 72) : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationStats() {
    final data = currentSemarangData;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Penduduk',
                '${data.populationInMillions} Juta jiwa',
                '${data.populationFormatted} jiwa',
                Icons.groups,
                Colors.brown,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDensityCard(data),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderCard(
                'Laki-laki',
                '${data.malePopulationInMillions} Juta jiwa',
                '${data.malePercentage.toStringAsFixed(1)}%',
                Icons.male,
                Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderCard(
                'Perempuan',
                '${data.femalePopulationInMillions} Juta jiwa',
                '${data.femalePercentage.toStringAsFixed(1)}%',
                Icons.female,
                Colors.pink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDensityCard(SemarangData data) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_city, color: Colors.blue, size: 24),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.densityFormatted,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'jiwa per km²',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Kepadatan',
              style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                'Luas: ${data.area?.toStringAsFixed(1) ?? 'N/A'} km²',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String title, String value, String percentage, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationChart() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laju Pertumbuhan Penduduk Kota Semarang (%)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 0.03, // Fixed to 3% (0.03 in decimal)
                  minX: 0,
                  maxX: (_cachedSpots.length - 1).toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.005, // 0.5% intervals
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color(0xFFE9ECEF),
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        interval: 0.005, // 0.5% intervals
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 9, color: Color(0xFF6C757D)),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < availableYears.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                availableYears[index].toString(),
                                style: const TextStyle(fontSize: 10, color: Color(0xFF6C757D)),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFFE9ECEF), width: 1),
                      bottom: BorderSide(color: Color(0xFFE9ECEF), width: 1),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _cachedSpots,
                      isCurved: true,
                      color: const Color(0xFF795548),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF795548).withOpacity(0.15),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final int index = barSpot.x.toInt();
                          if (index < 0 || index >= availableYears.length) return null;
                          
                          final year = availableYears[index];
                          final growthPercent = (barSpot.y * 100).toStringAsFixed(2);
                          
                          return LineTooltipItem(
                            '$year\n$growthPercent %',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          );
                        }).where((item) => item != null).map((item) => item!).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeDistributionChart() {
    // Only show if age data exists for selected year
    if (!_ageDataByYear.containsKey(selectedYear)) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribusi Umur Penduduk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: Center(
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: AnimatedBuilder(
                    animation: _pieChartAnimation,
                    builder: (context, child) {
                      final animationValue = 0.95 + (_pieChartAnimation.value * 0.1);
                      final sections = _cachedPieDataByYear[selectedYear] ?? [];
                      return PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: sections.map((section) {
                            return PieChartSectionData(
                              color: section.color,
                              value: section.value,
                              title: section.title,
                              radius: 60 * animationValue,
                              titleStyle: section.titleStyle,
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem('Usia Muda (0-14)', Colors.blue[400]!),
                const SizedBox(height: 8),
                _buildLegendItem('Usia Produktif (15-64)', Colors.green[400]!),
                const SizedBox(height: 8),
                _buildLegendItem('Usia Tua (65+)', Colors.orange[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF212529),
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictDensitySection() {
    final districts = currentDistrictDensity;
    
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5 Kecamatan Terpadat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 16),
            if (districts.isNotEmpty) ...[
              ...districts.asMap().entries.map((entry) {
                final index = entry.key;
                final district = entry.value;
                final ranking = index + 1;
                final circleColor = _districtColors[index];
                
                final totalCityPopulation = currentSemarangData.population ?? 1708833;
                final districtPopulationCount = (district.population * 1000).toInt();
                final percentage = (districtPopulationCount / totalCityPopulation * 100);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$ranking',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              district.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212529),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${district.populationFormatted} Ribu',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF495057),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 48, color: Color(0xFFADB5BD)),
                      const SizedBox(height: 8),
                      Text(
                        'Data kecamatan tidak tersedia untuk tahun $selectedYear',
                        style: const TextStyle(color: Color(0xFF6C757D), fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}