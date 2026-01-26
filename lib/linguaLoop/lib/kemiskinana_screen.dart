import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class KemiskinanScreen extends StatefulWidget {
  const KemiskinanScreen({super.key});

  @override
  State<KemiskinanScreen> createState() => _KemiskinanScreenState();
}

class _KemiskinanScreenState extends State<KemiskinanScreen> {
  int selectedYear = 2024;
  Map<int, Map<String, dynamic>> yearlyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('kemiskinan_data');
      
      if (mounted) {
        setState(() {
          if (savedData != null) {
            // Data dari admin
            final decoded = json.decode(savedData) as Map<String, dynamic>;
            yearlyData = decoded.map((key, value) => 
              MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
            );
          } else {
            // Data default jika belum ada dari admin
            yearlyData = {
              2020: {
                'pendudukMiskin': '79.58 Ribu',
                'pendudukMiskinValue': 79.58,
                'persentase': '4.34%',
                'persentaseValue': 4.34,
                'garisMiskin': 'Rp 533,691',
                'indeksKedalaman': '0.68',
                'indeksKeparahan': '0.16',
                'kemiskinanKota': '4.34%',
                'kemiskinanKotaChange': '+0.20%',
                'kemiskinanDesa': '12.82%',
                'kemiskinanDesaChange': '+0.27%',
              },
              2021: {
                'pendudukMiskin': '84.45 Ribu',
                'pendudukMiskinValue': 84.45,
                'persentase': '4.56%',
                'persentaseValue': 4.56,
                'garisMiskin': 'Rp 543,929',
                'indeksKedalaman': '0.67',
                'indeksKeparahan': '0.14',
                'kemiskinanKota': '4.56%',
                'kemiskinanKotaChange': '+0.28%',
                'kemiskinanDesa': '13.20%',
                'kemiskinanDesaChange': '+0.38%',
              },
              2022: {
                'pendudukMiskin': '79.87 Ribu',
                'pendudukMiskinValue': 79.87,
                'persentase': '4.25%',
                'persentaseValue': 4.25,
                'garisMiskin': 'Rp 589,598',
                'indeksKedalaman': '0.56',
                'indeksKeparahan': '0.11',
                'kemiskinanKota': '4.25%',
                'kemiskinanKotaChange': '-0.22%',
                'kemiskinanDesa': '12.34%',
                'kemiskinanDesaChange': '-0.86%',
              },
              2023: {
                'pendudukMiskin': '80.53 Ribu',
                'pendudukMiskinValue': 80.53,
                'persentase': '4.23%',
                'persentaseValue': 4.23,
                'garisMiskin': 'Rp 642,456',
                'indeksKedalaman': '0.54',
                'indeksKeparahan': '0.10',
                'kemiskinanKota': '4.23%',
                'kemiskinanKotaChange': '-0.41%',
                'kemiskinanDesa': '12.45%',
                'kemiskinanDesaChange': '-0.89%',
              },
              2024: {
                'pendudukMiskin': '77.79 Ribu',
                'pendudukMiskinValue': 77.79,
                'persentase': '4.03%',
                'persentaseValue': 4.03,
                'garisMiskin': 'Rp 671,936',
                'indeksKedalaman': '0.59',
                'indeksKeparahan': '0.12',
                'kemiskinanKota': '4.03%',
                'kemiskinanKotaChange': '-0.29%',
                'kemiskinanDesa': '12.11%',
                'kemiskinanDesaChange': '-0.34%',
              },
            };
          }
          
          // Set selected year ke tahun terbaru yang ada
          if (yearlyData.isNotEmpty) {
            selectedYear = yearlyData.keys.reduce((a, b) => a > b ? a : b);
          }
          
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kemiskinan', overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFFFF5722),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildYearSelector(),
                  const SizedBox(height: 20),
                  _buildPovertyStatsGrid(),
                  const SizedBox(height: 20),
                  _buildPovertyChart(),
                  const SizedBox(height: 20),
                  _buildInformationPanel(),
                ],
              ),
            ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFF5722),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (yearlyData.keys.toList()..sort())
                .map((year) {
                  final isSelected = year == selectedYear;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedYear = year;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFFFF5722),
                                    Colors.deepOrange.shade400
                                  ],
                                )
                              : null,
                          color: isSelected ? null : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          year.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPovertyStatsGrid() {
    if (yearlyData.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final data = yearlyData[selectedYear] ?? {};
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Jumlah Penduduk Miskin',
                data['pendudukMiskin']?.toString() ?? '-',
                Icons.people_outline,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Garis Kemiskinan (GK)',
                data['garisMiskin']?.toString() ?? '-',
                Icons.attach_money,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Persentase Penduduk Miskin (P0)',
                data['persentase']?.toString() ?? '-',
                Icons.pie_chart,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Indeks Kedalaman Kemiskinan (P1)',
                data['indeksKedalaman']?.toString() ?? '-',
                Icons.analytics,
                Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Indeks Keparahan Kemiskinan (P2)',
                data['indeksKeparahan']?.toString() ?? '-',
                Icons.trending_down,
                Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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

  Widget _buildPovertyChart() {
    return Column(
      children: [
        _buildAbsoluteCountChart(),
        const SizedBox(height: 20),
        _buildPercentageChart(),
      ],
    );
  }

  Widget _buildAbsoluteCountChart() {
    final years = yearlyData.keys.toList()..sort();

    if (years.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: Text('Tidak ada data untuk ditampilkan')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Penduduk Miskin (Ribu Jiwa)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Data Tren 2020 - 2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.people_outline, color: Color(0xFFFF6B9D), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} Ribu',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < years.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              years[index].toString(),
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 75,
                maxY: 87,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => Colors.white,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: BorderSide(color: Colors.grey[300]!, width: 1),
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < years.length) {
                          final yearData = yearlyData[years[index]];
                          final String value = yearData != null
                              ? (yearData['pendudukMiskin']?.toString() ?? '-')
                              : '-';
                          return LineTooltipItem(
                            '${years[index]}\n$value',
                            const TextStyle(
                              color: Color(0xFFFF6B9D),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: years
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                            e.key.toDouble(),
                            (yearlyData[e.value]?['pendudukMiskinValue'] as num?)
                                    ?.toDouble() ??
                                0))
                        .toList(),
                    isCurved: false,
                    color: const Color(0xFFFF6B9D),
                    barWidth: 3,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFFFF6B9D),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF6B9D).withOpacity(0.3),
                          const Color(0xFFFF6B9D).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDynamicIndicatorSingle(
            'Jumlah Penduduk Miskin',
            'pendudukMiskinValue',
            'pendudukMiskin',
            const Color(0xFFFF6B9D),
            ' Ribu',
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageChart() {
    final years = yearlyData.keys.toList()..sort();

    if (years.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: Text('Tidak ada data untuk ditampilkan')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Persentase Kemiskinan (%)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Data Tren 2020 - 2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.percent, color: Color(0xFF4ECDC4), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 0.2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < years.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              years[index].toString(),
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 3.8,
                maxY: 4.8,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => Colors.white,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: BorderSide(color: Colors.grey[300]!, width: 1),
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < years.length) {
                          final yearData = yearlyData[years[index]];
                          final String value = yearData != null
                              ? (yearData['persentase']?.toString() ?? '-')
                              : '-';
                          return LineTooltipItem(
                            '${years[index]}\n$value',
                            const TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: years
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                            e.key.toDouble(),
                            (yearlyData[e.value]?['persentaseValue'] as num?)
                                    ?.toDouble() ??
                                0))
                        .toList(),
                    isCurved: false,
                    color: const Color(0xFF4ECDC4),
                    barWidth: 3,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF4ECDC4),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4ECDC4).withOpacity(0.3),
                          const Color(0xFF4ECDC4).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDynamicIndicatorSingle(
            'Persentase Kemiskinan',
            'persentaseValue',
            'persentase',
            const Color(0xFF4ECDC4),
            '%',
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicIndicatorSingle(
    String title,
    String valueKey,
    String displayKey,
    Color color,
    String suffix,
  ) {
    if (yearlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final baseYear = yearlyData.keys.reduce((a, b) => a < b ? a : b);
    final baseValue = (yearlyData[baseYear]?[valueKey] as num?)?.toDouble() ?? 0;
    final currentValue = (yearlyData[selectedYear]?[valueKey] as num?)?.toDouble() ?? 0;
    final perubahan = baseValue - currentValue;
    final isPositive = perubahan > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedYear == baseYear
                ? title
                : '${isPositive ? "Penurunan" : "Kenaikan"} (dari $baseYear)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            selectedYear == baseYear
                ? (yearlyData[selectedYear]?[displayKey]?.toString() ?? '-')
                : '${perubahan.abs().toStringAsFixed(2)}$suffix',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (selectedYear != baseYear)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                isPositive ? '↓ Menurun' : '↑ Meningkat',
                style: TextStyle(
                  fontSize: 11,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildInformationPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'BPS mengukur kemiskinan menggunakan pendekatan kebutuhan dasar (basic need approach). Kemiskinan dipandang sebagai ketidakmampuan ekonomi seseorang dalam memenuhi kebutuhan dasar makanan maupun bukan makanan.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          _buildBulletPoint(
              'Garis Kemiskinan menjadi batas untuk menentukan apakah seseorang termasuk miskin. GK terdiri dari dua komponen:'),
          const SizedBox(height: 8),
          _buildSubBulletPoint(
              'Garis Kemiskinan Makanan (GKM): mencerminkan nilai pengeluaran kebutuhan minimum makanan yang disetarakan dengan 2.100 kalori per kapita per hari.'),
          const SizedBox(height: 6),
          _buildSubBulletPoint(
              'Garis Kemiskinan Bukan Makanan (GKBM): mencakup kebutuhan minimum untuk perumahan, sandang, pendidikan, dan kesehatan'),
          const SizedBox(height: 10),
          _buildBulletPoint(
              'Garis Kemiskinan per rumah tangga dihitung dari GK per kapita yang dikalikan dengan rata-rata jumlah anggota rumah tangga miskin.'),
          const SizedBox(height: 8),
          _buildBulletPoint(
              'Penduduk dikategorikan miskin apabila rata-rata pengeluaran per kapita per bulan berada di bawah Garis Kemiskinan.'),
          const SizedBox(height: 8),
          _buildBulletPoint(
              'Penghitungan tingkat kemiskinan menggunakan data Survei Sosial Ekonomi Nasional (Susenas).'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'a) ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}