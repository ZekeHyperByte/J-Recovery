import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IpmScreen extends StatefulWidget {
  const IpmScreen({super.key});

  @override
  _IpmScreenState createState() => _IpmScreenState();
}

class _IpmScreenState extends State<IpmScreen> with SingleTickerProviderStateMixin {
  int selectedYear = 2024;
  List<int> availableYears = [];
  bool isLoading = true;
  late AnimationController _;
  late AnimationController _animationController;
  int touchedIndex = -1;

  // Data yang akan dimuat dari SharedPreferences
  Map<int, Map<String, dynamic>> ipmData = {};
  Map<int, Map<String, dynamic>> komponenData = {};

  @override
void initState() {
  super.initState();
  _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);
  _loadData();
}

// TAMBAHKAN METHOD INI
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // Reload data setiap kali screen muncul kembali
  _loadData();
}

  // ============= LOAD DATA =============
  
  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      String? savedIpmData = prefs.getString('ipm_data');
      if (savedIpmData != null) {
        Map<String, dynamic> decoded = json.decode(savedIpmData);
        ipmData = decoded.map((key, value) =>
          MapEntry(int.parse(key), Map<String, dynamic>.from(value))
        );
      } else {
        _initializeDefaultIpmData();
      }

      String? savedKomponenData = prefs.getString('ipm_komponen_data');
      if (savedKomponenData != null) {
        Map<String, dynamic> decoded = json.decode(savedKomponenData);
        komponenData = decoded.map((key, value) =>
          MapEntry(int.parse(key), Map<String, dynamic>.from(value))
        );
      } else {
        _initializeDefaultKomponenData();
      }
      
      setState(() {
        availableYears = ipmData.keys.toList()..sort();
        if (availableYears.isNotEmpty && !availableYears.contains(selectedYear)) {
          selectedYear = availableYears.last;
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      _initializeDefaultIpmData();
      _initializeDefaultKomponenData();
      setState(() {
        availableYears = ipmData.keys.toList()..sort();
        if (availableYears.isNotEmpty) {
          selectedYear = availableYears.last;
        }
        isLoading = false;
      });
    }
  }

  void _initializeDefaultIpmData() {
  ipmData = {
    2020: {'uhh': 77.34, 'rls': 10.53, 'hls': 15.52, 'pengeluaran': 15243.00, 'ipm': 83.05},
    2021: {'uhh': 77.51, 'rls': 10.78, 'hls': 15.53, 'pengeluaran': 15425.00, 'ipm': 83.55},
    2022: {'uhh': 77.69, 'rls': 10.80, 'hls': 15.54, 'pengeluaran': 16047.00, 'ipm': 84.08},
    2023: {'uhh': 77.90, 'rls': 10.81, 'hls': 15.55, 'pengeluaran': 16420.00, 'ipm': 84.43},
    2024: {'uhh': 78.23, 'rls': 11.05, 'hls': 15.57, 'pengeluaran': 17250.00, 'ipm': 85.24}, // UBAH dari 0.0 ke 17250.00
  };
}

  void _initializeDefaultKomponenData() {
    komponenData = {
      2020: {'ipmNasional': 72.81, 'ipmJateng': 71.88, 'ipmSemarang': 83.05},
      2021: {'ipmNasional': 73.16, 'ipmJateng': 72.17, 'ipmSemarang': 83.55},
      2022: {'ipmNasional': 73.77, 'ipmJateng': 72.80, 'ipmSemarang': 84.08},
      2023: {'ipmNasional': 74.39, 'ipmJateng': 73.39, 'ipmSemarang': 84.43},
      2024: {'ipmNasional': 75.02, 'ipmJateng': 73.87, 'ipmSemarang': 85.24},
    };
  }

  // ============= HELPER FUNCTIONS =============

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(3)} Ribu';
    }
    return number.toStringAsFixed(2);
  }

  // ============= BUILD MAIN =============

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Indeks Pembangunan Manusia'),
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      );
    }

    if (availableYears.isEmpty || !ipmData.containsKey(selectedYear)) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Indeks Pembangunan Manusia'),
          backgroundColor: const Color(0xFF4CAF50),
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

    final currentData = ipmData[selectedYear]!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indeks Pembangunan Manusia', overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF4CAF50),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(),
              const SizedBox(height: 20),
              
              // Year Selector (Filter Tahun)
              _buildYearSelector(),
              const SizedBox(height: 20),
              
              // 1. Nilai Komponen IPM (UHH, HLS, RLS)
              _buildNilaiKomponenSection(currentData),
              const SizedBox(height: 20),
              
              // 2. Grafik Line dengan 3 Data (IPM Total: Semarang, Jateng, Nasional)
              _buildComparisonChart(),
              const SizedBox(height: 20),
              
              // 3. Penjelasan IPM
              _buildPenjelasanIPM(),
              const SizedBox(height: 20),
              
              // 4. Tabel Dimensi dan Indikator Penyusun IPM
              _buildTabelDimensi(),
              const SizedBox(height: 20),
              
              // 5. Catatan Tambahan
              _buildCatatanTambahan(),
            ],
          ),
        ),
      ),
    );
  }

  // ============= UI COMPONENTS =============

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.trending_up, color: Colors.white, size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indeks Pembangunan Manusia',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Data Kota Semarang - BPS',
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
                      color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
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

  // 1. Nilai Komponen IPM
  Widget _buildNilaiKomponenSection(Map<String, dynamic> data) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header dengan icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.assessment,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Nilai Komponen IPM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Item 1: UHH
        _buildKomponenItem(
          '1. Umur Harapan Hidup (UHH)',
          '${data['uhh'].toStringAsFixed(2)} Tahun',
          Icons.favorite,
          const Color(0xFFE91E63),
        ),
        const SizedBox(height: 12),
        
        // Item 2: HLS
        _buildKomponenItem(
          '2. Harapan Lama Sekolah (HLS)',
          '${data['hls'].toStringAsFixed(2)} Tahun',
          Icons.school,
          const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 12),
        
        // Item 3: RLS
        _buildKomponenItem(
          '3. Rata-rata Lama Sekolah (RLS)',
          '${data['rls'].toStringAsFixed(2)} Tahun',
          Icons.auto_stories,
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        
        // Item 4: Pengeluaran
        _buildKomponenItem(
          '4. Pengeluaran per Kapita',
          data['pengeluaran'] != null ? _formatNumber(data['pengeluaran']) : 'N/A',
          Icons.monetization_on,
          const Color(0xFFFF9800),
        ),
      ],
    ),
  );
}

// Helper widget untuk setiap item komponen
Widget _buildKomponenItem(String title, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // 2. Grafik Line dengan 3 Data
  // 2. Grafik Perbandingan IPM - Modern White Design
// 2. Grafik Perbandingan IPM - Modern White Design
Widget _buildComparisonChart() {
  if (komponenData.isEmpty) {
    return const SizedBox.shrink();
  }

  List<FlSpot> nasionalSpots = [];
  List<FlSpot> jatengSpots = [];
  List<FlSpot> semarangSpots = [];
  List<String> yearLabels = [];

  for (int i = 0; i < availableYears.length; i++) {
    final year = availableYears[i];
    
    if (!komponenData.containsKey(year)) continue;
    
    final data = komponenData[year]!;
    
    nasionalSpots.add(FlSpot(i.toDouble(), data['ipmNasional'].toDouble()));
    jatengSpots.add(FlSpot(i.toDouble(), data['ipmJateng'].toDouble()));
    semarangSpots.add(FlSpot(i.toDouble(), data['ipmSemarang'].toDouble()));
    yearLabels.add(year.toString());
  }

  if (semarangSpots.isEmpty) {
    return const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header dengan icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.show_chart,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Perbandingan IPM antar Wilayah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Legend info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'IPM Nasional, Jawa Tengah, dan Kota Semarang',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Chart
        SizedBox(
          height: 280,
          child: LineChart(
            LineChartData(
              minY: 70,
              maxY: 88,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
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
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                ),
              ),
              lineBarsData: [
                // Line 1: Semarang (Hijau)
                LineChartBarData(
                  spots: semarangSpots,
                  isCurved: true,
                  color: const Color(0xFF4CAF50),
                  barWidth: 3.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: const Color(0xFF4CAF50),
                        strokeWidth: 2.5,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF4CAF50).withOpacity(0.05),
                  ),
                ),
                // Line 2: Jawa Tengah (Biru)
                LineChartBarData(
                  spots: jatengSpots,
                  isCurved: true,
                  color: const Color(0xFF2196F3),
                  barWidth: 3.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: const Color(0xFF2196F3),
                        strokeWidth: 2.5,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF2196F3).withOpacity(0.05),
                  ),
                ),
                // Line 3: Nasional (Orange)
                LineChartBarData(
                  spots: nasionalSpots,
                  isCurved: true,
                  color: const Color(0xFFFF9800),
                  barWidth: 3.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: const Color(0xFFFF9800),
                        strokeWidth: 2.5,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFFF9800).withOpacity(0.05),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => const Color(0xFF1E3A5F),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((barSpot) {
                      final index = barSpot.x.toInt();
                      if (index >= 0 && index < availableYears.length) {
                        final year = yearLabels[index];
                        final value = barSpot.y.toStringAsFixed(2);
                        
                        String label = '';
                        if (barSpot.barIndex == 0) {
                          label = 'Semarang';
                        } else if (barSpot.barIndex == 1) {
                          label = 'Jawa Tengah';
                        } else {
                          label = 'Nasional';
                        }
                        
                        return LineTooltipItem(
                          '$year\n$label: $value',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        );
                      }
                      return null;
                    }).where((item) => item != null).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Legend
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Kota Semarang', const Color(0xFF4CAF50)),
              _buildLegendItem('Jawa Tengah', const Color(0xFF2196F3)),
              _buildLegendItem('Nasional', const Color(0xFFFF9800)),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper widget untuk legend item
Widget _buildLegendItem(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    ],
  );
}

  // 3. Penjelasan IPM
  Widget _buildPenjelasanIPM() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Penjelasan IPM',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Indeks Pembangunan Manusia (IPM) mengukur tingkat kemampuan suatu wilayah dalam aspek Kesehatan, Pendidikan dan Pendapatan yang mencerminkan kualitas hidup serta kesejahteraan masyarakatnya. penyempurnaan metode perhitungan IPM  mengalami perubahan yang signifikan pada tahun 2010 dengan mengubah indikator Angka Melek Huruf (AMH) dan Angka Partisipasi Kasar (APK) menjadi indikator Rata-rata Lama Sekolah (RLS) dan Harapan Lama Sekolah (HLS). Selain melakukan perubahan cara perhitungan, metode perhitungan agregasi indeks juga mulai menggunakan rata-rata geometrik. Berikut DImensi dan Indikator Penyusun IPM menurut BPS, yaitu :',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 0, 0, 0),
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // 4. Tabel Dimensi dan Indikator
  Widget _buildTabelDimensi() {
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
            'Dimensi dan Indikator Penyusun IPM BPS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.orange.shade200, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.orange.shade100),
                children: [
                  _buildTableCell('Dimensi', isHeader: true),
                  _buildTableCell('Indikator', isHeader: true),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                children: [
                  _buildTableCell('Umur Panjang dan Hidup Sehat'),
                  _buildTableCell('Angka Harapan Hidup (UHH)'),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Pengetahuan'),
                  _buildTableCell('Harapan Lama Sekolah (HLS)\nRata-rata Lama Sekolah (RLS)'),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Colors.orange.shade50),
                children: [
                  _buildTableCell('Standar Hidup Layak'),
                  _buildTableCell('Pengeluaran Riil Perkapita per tahun yang disesuaikan'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 13 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.grey[800] : Colors.grey[700],
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildCatatanTambahan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Penjelasan Indikator:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 12),
          _buildCatatanItem(
            '• Umur Harapan Hidup saat Lahir',
            'Indikator yang mengukur dimensi kesehatan yang memperkirakan rata-rata usia harapan hidup seseorang sejak lahir.',
          ),
          const SizedBox(height: 12),
          _buildCatatanItem(
            '• Harapan Lama Sekolah',
            'Indikator yang mengukur dimensi pendidikan dan menggambarkan lamanya masa sekolah yang diharapkan dapat dicapai oleh anak-anak dimasa depan (sejak usia 7 tahun).',
          ),
          const SizedBox(height: 12),
          _buildCatatanItem(
            '• Rata-Rata Lama Sekolah',
            'Indikator yang mengukur dimensi pendidikan yang menggambarkan lamanya masa sekolah yang sudah dialami oleh penduduk dewasa (usia 25 tahun ke atas).',
          ),
          const SizedBox(height: 12),
          _buildCatatanItem(
            '• Pengeluaran Riil Perkapita Per Tahun yang Disesuaikan',
            'Menunjukkan kemampuan masyarakat untuk membeli barang dan jasa yang dibutuhkan untuk standar hidup yang layak.',
          ),
        ],
      ),
    );
  }

  Widget _buildCatatanItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 0, 0, 0),
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}