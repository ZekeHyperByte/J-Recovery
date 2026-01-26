import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TenagaKerjaScreen extends StatefulWidget {
  const TenagaKerjaScreen({super.key});

  @override
  _TenagaKerjaScreenState createState() => _TenagaKerjaScreenState();
}

class _TenagaKerjaScreenState extends State<TenagaKerjaScreen> with SingleTickerProviderStateMixin {
  int selectedYear = 2024;
  List<int> availableYears = [2020, 2021, 2022, 2023, 2024];
  late AnimationController _animationController;
  int touchedIndex = -1;
  bool isLoading = true;

  // Data yang akan dimuat dari SharedPreferences
  Map<int, Map<String, dynamic>> yearData = {};
  Map<int, Map<String, dynamic>> indikatorData = {};
  Map<int, Map<String, double>> distribusiData = {};
  Map<int, Map<String, dynamic>> jatengData = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============= LOAD DATA FROM SHARED PREFERENCES =============
  
  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Load Year Data
      String? savedYearData = prefs.getString('tenaga_kerja_year_data');
      if (savedYearData != null) {
        Map<String, dynamic> decoded = json.decode(savedYearData);
        yearData = decoded.map((key, value) => 
          MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
        );
      } else {
        _initializeDefaultYearData();
      }

      // Load Indikator Data
      String? savedIndikatorData = prefs.getString('tenaga_kerja_indikator_data');
      if (savedIndikatorData != null) {
        Map<String, dynamic> decoded = json.decode(savedIndikatorData);
        indikatorData = decoded.map((key, value) => 
          MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
        );
      } else {
        _initializeDefaultIndikatorData();
      }

      // Load Distribusi Data
      String? savedDistribusiData = prefs.getString('tenaga_kerja_distribusi_data');
      if (savedDistribusiData != null) {
        Map<String, dynamic> decoded = json.decode(savedDistribusiData);
        distribusiData = decoded.map((key, value) => 
          MapEntry(int.parse(key), Map<String, double>.from(value as Map))
        );
      } else {
        _initializeDefaultDistribusiData();
      }

      // Load Jateng Data
      String? savedJatengData = prefs.getString('tenaga_kerja_jateng_data');
      if (savedJatengData != null) {
        Map<String, dynamic> decoded = json.decode(savedJatengData);
        jatengData = decoded.map((key, value) => 
          MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
        );
      } else {
        _initializeDefaultJatengData();
      }
      
      setState(() {
        availableYears = yearData.keys.toList()..sort();
        if (availableYears.isNotEmpty && !availableYears.contains(selectedYear)) {
          selectedYear = availableYears.last;
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      _initializeDefaultYearData();
      _initializeDefaultIndikatorData();
      _initializeDefaultDistribusiData();
      _initializeDefaultJatengData();
      setState(() {
        availableYears = yearData.keys.toList()..sort();
        if (availableYears.isNotEmpty) {
          selectedYear = availableYears.last;
        }
        isLoading = false;
      });
    }
  }

  // ============= DEFAULT DATA INITIALIZATION =============
  
  void _initializeDefaultYearData() {
    yearData = {
      2020: {'angkatanKerja': 1023964, 'bekerja': 925963, 'pengangguran': 98001, 'bukanAngkatanKerja': 441157, 'tpt': 9.57, 'tkk': 90.43, 'tpak': 69.89},
      2021: {'angkatanKerja': 1034794, 'bekerja': 936076, 'pengangguran': 98718, 'bukanAngkatanKerja': 455948, 'tpt': 9.54, 'tkk': 90.46, 'tpak': 69.41},
      2022: {'angkatanKerja': 1075827, 'bekerja': 994091, 'pengangguran': 81736, 'bukanAngkatanKerja': 440370, 'tpt': 7.60, 'tkk': 92.40, 'tpak': 70.96},
      2023: {'angkatanKerja': 929014, 'bekerja': 873358, 'pengangguran': 55656, 'bukanAngkatanKerja': 409201, 'tpt': 5.99, 'tkk': 94.01, 'tpak': 69.42},
      2024: {'angkatanKerja': 946618, 'bekerja': 891497, 'pengangguran': 55121, 'bukanAngkatanKerja': 407975, 'tpt': 5.82, 'tkk': 94.18, 'tpak': 69.88},
    };
  }

  void _initializeDefaultIndikatorData() {
    indikatorData = {
      2020: {'tptLaki': 10.08, 'tptPerempuan': 8.94, 'tptTotal': 9.57, 'tkkLaki': 89.92, 'tkkPerempuan': 91.06, 'tkkTotal': 90.43, 'tpakLaki': 79.86, 'tpakPerempuan': 60.48, 'tpakTotal': 69.89},
      2021: {'tptLaki': 10.01, 'tptPerempuan': 8.94, 'tptTotal': 9.54, 'tkkLaki': 89.99, 'tkkPerempuan': 91.06, 'tkkTotal': 90.46, 'tpakLaki': 79.99, 'tpakPerempuan': 59.42, 'tpakTotal': 69.41},
      2022: {'tptLaki': 9.91, 'tptPerempuan': 4.46, 'tptTotal': 7.60, 'tkkLaki': 90.09, 'tkkPerempuan': 95.54, 'tkkTotal': 92.40, 'tpakLaki': 84.03, 'tpakPerempuan': 58.59, 'tpakTotal': 70.96},
      2023: {'tptLaki': 4.91, 'tptPerempuan': 7.33, 'tptTotal': 5.99, 'tkkLaki': 95.09, 'tkkPerempuan': 92.67, 'tkkTotal': 94.01, 'tpakLaki': 78.56, 'tpakPerempuan': 60.64, 'tpakTotal': 69.42},
      2024: {'tptLaki': 3.58, 'tptPerempuan': 8.68, 'tptTotal': 5.82, 'tkkLaki': 96.42, 'tkkPerempuan': 91.32, 'tkkTotal': 94.18, 'tpakLaki': 79.92, 'tpakPerempuan': 60.24, 'tpakTotal': 69.88},
    };
  }

  void _initializeDefaultDistribusiData() {
    distribusiData = {
      2020: {'Pertanian': 2.00, 'Manufaktur': 26.00, 'Jasa': 73.00},
      2021: {'Pertanian': 2.00, 'Manufaktur': 26.00, 'Jasa': 72.00},
      2022: {'Pertanian': 1.00, 'Manufaktur': 28.00, 'Jasa': 70.00},
      2023: {'Pertanian': 2.00, 'Manufaktur': 26.00, 'Jasa': 72.00},
      2024: {'Pertanian': 2.00, 'Manufaktur': 28.00, 'Jasa': 70.00},
    };
  }

  void _initializeDefaultJatengData() {
    jatengData = {
      2020: {'bekerja': 17536935, 'pengangguran': 1214342, 'bukanAngkatanKerja': 8258019},
      2021: {'bekerja': 17835770, 'pengangguran': 1128223, 'bukanAngkatanKerja': 8289921},
      2022: {'bekerja': 18390459, 'pengangguran': 1084475, 'bukanAngkatanKerja': 8015925},
      2023: {'bekerja': 19988875, 'pengangguran': 1080260, 'bukanAngkatanKerja': 8308494},
      2024: {'bekerja': 20861393, 'pengangguran': 1047451, 'bukanAngkatanKerja': 7803338},
    };
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)} Juta';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)} Ribu';
    }
    return number.toString();
  }

  String _getChangeText(int year, String key) {
    if (year == availableYears.first) return '0%';
    
    final currentIndex = availableYears.indexOf(year);
    if (currentIndex <= 0) return '0%';
    
    final prevYear = availableYears[currentIndex - 1];
    if (!yearData.containsKey(prevYear)) return '0%';
    
    final currentValue = yearData[year]![key] as num;
    final prevValue = yearData[prevYear]![key] as num;
    final change = ((currentValue - prevValue) / prevValue * 100);
    
    return '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tenaga Kerja'),
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1976D2)),
        ),
      );
    }

    if (availableYears.isEmpty || !yearData.containsKey(selectedYear)) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tenaga Kerja'),
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Data tidak tersedia',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final currentData = yearData[selectedYear]!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenaga Kerja', overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildYearSelector(),
              const SizedBox(height: 20),
              _buildStatisticsCards(currentData),
              const SizedBox(height: 20),
              _buildUnemploymentChart(),
              const SizedBox(height: 20),
              _buildWorkforceChart(),
              const SizedBox(height: 20),
              _buildSectorAnalysis(selectedYear),
            ],
          ),
        ),
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
                      color: isSelected ? const Color(0xFF1976D2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1976D2) : Colors.grey[300]!,
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

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.work, color: Colors.white, size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik Tenaga Kerja',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Data Kota Semarang - BPS Sakernas',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(Map<String, dynamic> data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Jumlah Angkatan Kerja',
                _formatNumber(data['angkatanKerja']),
                Icons.groups,
                const Color(0xFF1976D2),
                _getChangeText(selectedYear, 'angkatanKerja'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Angkatan Kerja Yang Bekerja',
                _formatNumber(data['bekerja']),
                Icons.work_outline,
                const Color(0xFF388E3C),
                _getChangeText(selectedYear, 'bekerja'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Jumlah Bukan Angkatan Kerja',
                _formatNumber(data['bukanAngkatanKerja']),
                Icons.person_off,
                const Color(0xFF7B1FA2),
                _getChangeText(selectedYear, 'bukanAngkatanKerja'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pengangguran Terbuka',
                _formatNumber(data['pengangguran']),
                Icons.trending_down,
                const Color(0xFFD32F2F),
                _getChangeText(selectedYear, 'pengangguran'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String change) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnemploymentChart() {
    List<FlSpot> semarangSpots = [];
    List<FlSpot> jatengSpots = [];
    List<String> yearLabels = [];

    for (int i = 0; i < availableYears.length; i++) {
      final year = availableYears[i];
      
      if (!yearData.containsKey(year) || !jatengData.containsKey(year)) continue;
      
      final semarangData = yearData[year]!;
      final semarangAK = semarangData['angkatanKerja'] as int;
      final semarangPengangguran = semarangData['pengangguran'] as int;
      final semarangTPT = (semarangPengangguran / semarangAK) * 100;
      
      final jatengDataYear = jatengData[year]!;
      final jatengBekerja = jatengDataYear['bekerja'] as int;
      final jatengPengangguran = jatengDataYear['pengangguran'] as int;
      final jatengAK = jatengBekerja + jatengPengangguran;
      final jatengTPT = (jatengPengangguran / jatengAK) * 100;
      
      semarangSpots.add(FlSpot(i.toDouble(), semarangTPT));
      jatengSpots.add(FlSpot(i.toDouble(), jatengTPT));
      yearLabels.add(year.toString());
    }

    if (semarangSpots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Data chart tidak tersedia'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tingkat Pengangguran Terbuka (TPT)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kota Semarang dan Jawa Tengah',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: 4,
                maxY: 11,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF4472C4),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFED7D31),
                            fontWeight: FontWeight.w500,
                          ),
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
                        final index = value.toInt();
                        if (index >= 0 && index < yearLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              yearLabels[index],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                    right: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: semarangSpots,
                    isCurved: true,
                    color: const Color(0xFF4472C4),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF4472C4),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: jatengSpots,
                    isCurved: true,
                    color: const Color(0xFFED7D31),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFFED7D31),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        final index = barSpot.x.toInt();
                        if (index >= 0 && index < availableYears.length) {
                          final year = yearLabels[index];
                          final value = barSpot.y.toStringAsFixed(2);
                          
                          if (barSpot.barIndex == 0) {
                            return LineTooltipItem(
                              '$year\nSemarang: $value%',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            );
                          } else {
                            return LineTooltipItem(
                              '$year\nJawa Tengah: $value%',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            );
                          }
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4472C4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kota Semarang',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFED7D31),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jawa Tengah',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkforceChart() {
    if (!distribusiData.containsKey(selectedYear)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Data distribusi tidak tersedia'),
        ),
      );
    }

    final currentDistribusi = distribusiData[selectedYear]!;

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
              Icon(Icons.bar_chart, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Distribusi Penduduk Bekerja',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Menurut Lapangan Usaha di Kota Semarang',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: 80,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.black87,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label;
                      switch (groupIndex) {
                        case 0:
                          label = 'Pertanian';
                          break;
                        case 1:
                          label = 'Manufaktur';
                          break;
                        case 2:
                          label = 'Jasa';
                          break;
                        default:
                          label = '';
                      }
                      return BarTooltipItem(
                        '$label\n${rod.toY.toStringAsFixed(0)}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Pertanian', style: style);
                            break;
                          case 1:
                            text = const Text('Manufaktur', style: style);
                            break;
                          case 2:
                            text = const Text('Jasa', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: text,
                        );
                      },
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: currentDistribusi['Pertanian']!,
                        color: const Color(0xFF388E3C),
                        width: touchedIndex == 0 ? 60 : 50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 80,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: touchedIndex == 0 ? [0] : [],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: currentDistribusi['Manufaktur']!,
                        color: const Color(0xFF1976D2),
                        width: touchedIndex == 1 ? 60 : 50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 80,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: touchedIndex == 1 ? [0] : [],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: currentDistribusi['Jasa']!,
                        color: const Color(0xFFF57C00),
                        width: touchedIndex == 2 ? 60 : 50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 80,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: touchedIndex == 2 ? [0] : [],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Pertanian', const Color(0xFF388E3C),
                  currentDistribusi['Pertanian']!),
              _buildLegendItem('Manufaktur', const Color(0xFF1976D2),
                  currentDistribusi['Manufaktur']!),
              _buildLegendItem('Jasa', const Color(0xFFF57C00),
                  currentDistribusi['Jasa']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double percentage) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectorAnalysis(int year) {
    if (!indikatorData.containsKey(year)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Data indikator tidak tersedia'),
        ),
      );
    }

    final indikator = indikatorData[year]!;
    
    final Map<int, double> dependencyRatio = {
      2020: 28.52,
      2021: 28.59,
      2022: 28.68,
      2023: 28.77,
      2024: 28.91,
    };
    
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
          Text(
            'Indikator Ketenagakerjaan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 15),
          _buildAnalysisItem(
            'Tingkat Pengangguran Terbuka (TPT)',
            '${indikator['tptTotal']}%',
            'Laki-laki: ${indikator['tptLaki']}% | Perempuan: ${indikator['tptPerempuan']}%',
            Icons.trending_down,
            const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 10),
          _buildAnalysisItem(
            'Tingkat Partisipasi Angkatan Kerja (TPAK)',
            '${indikator['tpakTotal']}%',
            'Laki-laki: ${indikator['tpakLaki']}% | Perempuan: ${indikator['tpakPerempuan']}%',
            Icons.trending_up,
            const Color(0xFF1976D2),
          ),
          const SizedBox(height: 10),
          _buildAnalysisItem(
            'Tingkat Kesempatan Kerja (TKK)',
            '${indikator['tkkTotal']}%',
            'Laki-laki: ${indikator['tkkLaki']}% | Perempuan: ${indikator['tkkPerempuan']}%',
            Icons.work_outline,
            const Color(0xFF388E3C),
          ),
          if (dependencyRatio.containsKey(year)) ...[
            const SizedBox(height: 10),
            _buildAnalysisItem(
              'Angka Ketergantungan',
              '${dependencyRatio[year]!.toStringAsFixed(2)}',
              'Rasio ketergantungan penduduk Kota Semarang',
              Icons.info_outline,
              const Color(0xFF7B1FA2),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String value, String description,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}