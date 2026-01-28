import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'responsive_sizing.dart';

// BPS Color Palette (matching home_screen.dart)
const Color _bpsBlue = Color(0xFF2E99D6);
const Color _bpsOrange = Color(0xFFE88D34);
const Color _bpsGreen = Color(0xFF7DBD42);
const Color _bpsRed = Color(0xFFEF4444);
const Color _bpsBackground = Color(0xFFF5F5F5);
const Color _bpsCardBg = Color(0xFFFFFFFF);
const Color _bpsTextPrimary = Color(0xFF333333);
const Color _bpsTextSecondary = Color(0xFF808080);
const Color _bpsTextLabel = Color(0xFFA0A0A0);
const Color _bpsBorder = Color(0xFFE0E0E0);
const Color _bpsPurple = Color(0xFF7B1FA2);

class TenagaKerjaScreen extends StatefulWidget {
  const TenagaKerjaScreen({super.key});

  @override
  _TenagaKerjaScreenState createState() => _TenagaKerjaScreenState();
}

class _TenagaKerjaScreenState extends State<TenagaKerjaScreen> {
  int selectedYear = 2024;
  List<int> availableYears = [2020, 2021, 2022, 2023, 2024];
  int touchedIndex = -1;
  bool isLoading = true;

  Map<int, Map<String, dynamic>> yearData = {};
  Map<int, Map<String, dynamic>> indikatorData = {};
  Map<int, Map<String, double>> distribusiData = {};
  Map<int, Map<String, dynamic>> jatengData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ============= LOAD DATA FROM SHARED PREFERENCES =============

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? savedYearData = prefs.getString('tenaga_kerja_year_data');
      if (savedYearData != null) {
        Map<String, dynamic> decoded = json.decode(savedYearData);
        yearData = decoded.map((key, value) =>
          MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
        );
      } else {
        _initializeDefaultYearData();
      }

      String? savedIndikatorData = prefs.getString('tenaga_kerja_indikator_data');
      if (savedIndikatorData != null) {
        Map<String, dynamic> decoded = json.decode(savedIndikatorData);
        indikatorData = decoded.map((key, value) =>
          MapEntry(int.parse(key), Map<String, dynamic>.from(value as Map))
        );
      } else {
        _initializeDefaultIndikatorData();
      }

      String? savedDistribusiData = prefs.getString('tenaga_kerja_distribusi_data');
      if (savedDistribusiData != null) {
        Map<String, dynamic> decoded = json.decode(savedDistribusiData);
        distribusiData = decoded.map((key, value) =>
          MapEntry(int.parse(key), Map<String, double>.from(value as Map))
        );
      } else {
        _initializeDefaultDistribusiData();
      }

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
    final sizing = ResponsiveSizing(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: _bpsBackground,
        appBar: AppBar(
          title: const Text('Tenaga Kerja'),
          backgroundColor: _bpsBlue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: _bpsBlue),
        ),
      );
    }

    if (availableYears.isEmpty || !yearData.containsKey(selectedYear)) {
      return Scaffold(
        backgroundColor: _bpsBackground,
        appBar: AppBar(
          title: const Text('Tenaga Kerja'),
          backgroundColor: _bpsBlue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: sizing.isVerySmall ? 48 : 64, color: _bpsTextLabel),
              SizedBox(height: sizing.itemSpacing),
              Text(
                'Data tidak tersedia',
                style: TextStyle(fontSize: sizing.sectionTitleSize, color: _bpsTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bpsBackground,
      appBar: AppBar(
        title: const Text('Tenaga Kerja', overflow: TextOverflow.ellipsis),
        backgroundColor: _bpsBlue,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: RefreshIndicator(
        color: _bpsBlue,
        onRefresh: _loadData,
        child: _TenagaKerjaContent(
          selectedYear: selectedYear,
          availableYears: availableYears,
          yearData: yearData,
          indikatorData: indikatorData,
          distribusiData: distribusiData,
          jatengData: jatengData,
          touchedIndex: touchedIndex,
          sizing: sizing,
          onYearSelected: (year) => setState(() => selectedYear = year),
          onTouchedIndexChanged: (index) => setState(() => touchedIndex = index),
          formatNumber: _formatNumber,
          getChangeText: _getChangeText,
        ),
      ),
    );
  }
}

class _TenagaKerjaContent extends StatelessWidget {
  final int selectedYear;
  final List<int> availableYears;
  final Map<int, Map<String, dynamic>> yearData;
  final Map<int, Map<String, dynamic>> indikatorData;
  final Map<int, Map<String, double>> distribusiData;
  final Map<int, Map<String, dynamic>> jatengData;
  final int touchedIndex;
  final ResponsiveSizing sizing;
  final ValueChanged<int> onYearSelected;
  final ValueChanged<int> onTouchedIndexChanged;
  final String Function(int) formatNumber;
  final String Function(int, String) getChangeText;

  const _TenagaKerjaContent({
    required this.selectedYear,
    required this.availableYears,
    required this.yearData,
    required this.indikatorData,
    required this.distribusiData,
    required this.jatengData,
    required this.touchedIndex,
    required this.sizing,
    required this.onYearSelected,
    required this.onTouchedIndexChanged,
    required this.formatNumber,
    required this.getChangeText,
  });

  @override
  Widget build(BuildContext context) {
    final currentData = yearData[selectedYear]!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(sizing.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                SizedBox(height: sizing.sectionSpacing - 4),
                _buildYearSelector(),
                SizedBox(height: sizing.sectionSpacing - 4),
                _buildStatisticsCards(currentData),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizing.horizontalPadding),
            child: _UnemploymentChart(
              availableYears: availableYears,
              yearData: yearData,
              jatengData: jatengData,
              sizing: sizing,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: sizing.horizontalPadding,
              right: sizing.horizontalPadding,
              top: sizing.sectionSpacing - 4,
            ),
            child: _WorkforceChart(
              selectedYear: selectedYear,
              distribusiData: distribusiData,
              touchedIndex: touchedIndex,
              onTouchedIndexChanged: onTouchedIndexChanged,
              sizing: sizing,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: sizing.horizontalPadding,
              right: sizing.horizontalPadding,
              top: sizing.sectionSpacing - 4,
              bottom: sizing.sectionSpacing,
            ),
            child: _SectorAnalysis(
              year: selectedYear,
              indikatorData: indikatorData,
              sizing: sizing,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_bpsBlue, Color(0xFF5BB8E8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(_bpsBlue.r.toInt(), _bpsBlue.g.toInt(), _bpsBlue.b.toInt(), 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.work, color: Colors.white, size: sizing.isVerySmall ? 32 : 40),
          SizedBox(width: sizing.itemSpacing + 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik Tenaga Kerja',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sizing.sectionTitleSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Data Kota Semarang - BPS Sakernas',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: sizing.categoryLabelFontSize - 1,
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
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bpsBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
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
              Icon(Icons.calendar_today, color: _bpsTextSecondary, size: sizing.groupIconSize),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: sizing.categoryLabelFontSize,
                  fontWeight: FontWeight.w500,
                  color: _bpsTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.itemSpacing),
          Wrap(
            spacing: sizing.itemSpacing,
            runSpacing: sizing.itemSpacing,
            alignment: WrapAlignment.start,
            children: availableYears.map((year) {
              final isSelected = year == selectedYear;
              return SizedBox(
                width: sizing.isVerySmall ? 56 : 63,
                child: Material(
                  color: isSelected ? _bpsBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => onYearSelected(year),
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Color.fromRGBO(
                      _bpsBlue.r.toInt(), _bpsBlue.g.toInt(), _bpsBlue.b.toInt(), 0.2,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: sizing.itemSpacing - 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? _bpsBlue : _bpsBorder,
                        ),
                      ),
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : _bpsTextSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: sizing.bottomNavLabelSize + 1,
                        ),
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

  Widget _buildStatisticsCards(Map<String, dynamic> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSingleColumn = constraints.maxWidth < 300;

        final cards = [
          _buildStatCard(
            'Jumlah Angkatan Kerja',
            formatNumber(data['angkatanKerja']),
            Icons.groups,
            _bpsBlue,
            getChangeText(selectedYear, 'angkatanKerja'),
          ),
          _buildStatCard(
            'Angkatan Kerja Yang Bekerja',
            formatNumber(data['bekerja']),
            Icons.work_outline,
            _bpsGreen,
            getChangeText(selectedYear, 'bekerja'),
          ),
          _buildStatCard(
            'Jumlah Bukan Angkatan Kerja',
            formatNumber(data['bukanAngkatanKerja']),
            Icons.person_off,
            _bpsPurple,
            getChangeText(selectedYear, 'bukanAngkatanKerja'),
          ),
          _buildStatCard(
            'Pengangguran Terbuka',
            formatNumber(data['pengangguran']),
            Icons.trending_down,
            _bpsRed,
            getChangeText(selectedYear, 'pengangguran'),
          ),
        ];

        if (useSingleColumn) {
          return Column(
            children: cards.map((card) => Padding(
              padding: EdgeInsets.only(bottom: sizing.itemSpacing),
              child: card,
            )).toList(),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: cards[0]),
                SizedBox(width: sizing.itemSpacing),
                Expanded(child: cards[1]),
              ],
            ),
            SizedBox(height: sizing.itemSpacing),
            Row(
              children: [
                Expanded(child: cards[2]),
                SizedBox(width: sizing.itemSpacing),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bpsBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
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
              Icon(icon, color: color, size: sizing.categoryIconSize),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizing.isVerySmall ? 4 : 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(color.r.toInt(), color.g.toInt(), color.b.toInt(), 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: sizing.statsChangeFontSize,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.itemSpacing),
          Text(
            value,
            style: TextStyle(
              fontSize: sizing.sectionTitleSize,
              fontWeight: FontWeight.bold,
              color: _bpsTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: sizing.bottomNavLabelSize + 1,
              color: _bpsTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnemploymentChart extends StatelessWidget {
  final List<int> availableYears;
  final Map<int, Map<String, dynamic>> yearData;
  final Map<int, Map<String, dynamic>> jatengData;
  final ResponsiveSizing sizing;

  const _UnemploymentChart({
    required this.availableYears,
    required this.yearData,
    required this.jatengData,
    required this.sizing,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(sizing.statsCardPadding),
        decoration: BoxDecoration(
          color: _bpsCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('Data chart tidak tersedia')),
      );
    }

    final chartHeight = (sizing.screenWidth * 0.55).clamp(180.0, 280.0);

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bpsBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
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
              Icon(Icons.show_chart, color: _bpsTextSecondary, size: sizing.sectionIconSize),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Text(
                  'Tingkat Pengangguran Terbuka (TPT)',
                  style: TextStyle(
                    fontSize: sizing.sectionTitleSize - 2,
                    fontWeight: FontWeight.bold,
                    color: _bpsTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kota Semarang dan Jawa Tengah',
            style: TextStyle(
              fontSize: sizing.bottomNavLabelSize + 1,
              color: _bpsTextSecondary,
            ),
          ),
          SizedBox(height: sizing.itemSpacing + 4),
          SizedBox(
            height: chartHeight,
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
                      color: const Color.fromRGBO(158, 158, 158, 0.2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: sizing.isVerySmall ? 30 : 35,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: sizing.statsChangeFontSize,
                            color: const Color(0xFF4472C4),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: sizing.isVerySmall ? 30 : 35,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: sizing.statsChangeFontSize,
                            color: const Color(0xFFED7D31),
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
                              style: TextStyle(
                                fontSize: sizing.statsChangeFontSize,
                                color: _bpsTextSecondary,
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
                  border: const Border(
                    left: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.3), width: 1),
                    right: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.3), width: 1),
                    bottom: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.3), width: 1),
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
                          radius: sizing.isVerySmall ? 3 : 4,
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
                          radius: sizing.isVerySmall ? 3 : 4,
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
                        if (index >= 0 && index < yearLabels.length) {
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
          SizedBox(height: sizing.itemSpacing + 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot('Kota Semarang', const Color(0xFF4472C4)),
              SizedBox(width: sizing.sectionSpacing),
              _buildLegendDot('Jawa Tengah', const Color(0xFFED7D31)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Column(
      children: [
        Container(
          width: sizing.isVerySmall ? 12 : 16,
          height: sizing.isVerySmall ? 12 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: sizing.bottomNavLabelSize + 1, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _WorkforceChart extends StatelessWidget {
  final int selectedYear;
  final Map<int, Map<String, double>> distribusiData;
  final int touchedIndex;
  final ValueChanged<int> onTouchedIndexChanged;
  final ResponsiveSizing sizing;

  const _WorkforceChart({
    required this.selectedYear,
    required this.distribusiData,
    required this.touchedIndex,
    required this.onTouchedIndexChanged,
    required this.sizing,
  });

  @override
  Widget build(BuildContext context) {
    if (!distribusiData.containsKey(selectedYear)) {
      return Container(
        padding: EdgeInsets.all(sizing.statsCardPadding),
        decoration: BoxDecoration(
          color: _bpsCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('Data distribusi tidak tersedia')),
      );
    }

    final currentDistribusi = distribusiData[selectedYear]!;
    final chartHeight = (sizing.screenWidth * 0.55).clamp(180.0, 260.0);
    final barWidth = (sizing.screenWidth * 0.12).clamp(30.0, 50.0);
    final barWidthTouched = barWidth + 10;

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bpsBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
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
              Icon(Icons.bar_chart, color: _bpsTextSecondary, size: sizing.sectionIconSize),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Text(
                  'Distribusi Penduduk Bekerja',
                  style: TextStyle(
                    fontSize: sizing.sectionTitleSize - 2,
                    fontWeight: FontWeight.bold,
                    color: _bpsTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Menurut Lapangan Usaha di Kota Semarang',
            style: TextStyle(
              fontSize: sizing.bottomNavLabelSize + 1,
              color: _bpsTextSecondary,
            ),
          ),
          SizedBox(height: sizing.sectionSpacing - 8),
          SizedBox(
            height: chartHeight,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: 80,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      onTouchedIndexChanged(-1);
                      return;
                    }
                    onTouchedIndexChanged(barTouchResponse.spot!.touchedBarGroupIndex);
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.black87,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label;
                      switch (groupIndex) {
                        case 0: label = 'Pertanian'; break;
                        case 1: label = 'Manufaktur'; break;
                        case 2: label = 'Jasa'; break;
                        default: label = '';
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
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final style = TextStyle(
                          color: _bpsTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: sizing.bottomNavLabelSize + 1,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = Text('Pertanian', style: style); break;
                          case 1: text = Text('Manufaktur', style: style); break;
                          case 2: text = Text('Jasa', style: style); break;
                          default: text = Text('', style: style); break;
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
                      reservedSize: sizing.isVerySmall ? 32 : 40,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: _bpsTextSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: sizing.statsChangeFontSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color.fromRGBO(158, 158, 158, 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: [
                  _barGroup(0, currentDistribusi['Pertanian']!, _bpsGreen, barWidth, barWidthTouched),
                  _barGroup(1, currentDistribusi['Manufaktur']!, _bpsBlue, barWidth, barWidthTouched),
                  _barGroup(2, currentDistribusi['Jasa']!, _bpsOrange, barWidth, barWidthTouched),
                ],
              ),
            ),
          ),
          SizedBox(height: sizing.sectionSpacing - 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Pertanian', _bpsGreen, currentDistribusi['Pertanian']!),
              _buildLegendItem('Manufaktur', _bpsBlue, currentDistribusi['Manufaktur']!),
              _buildLegendItem('Jasa', _bpsOrange, currentDistribusi['Jasa']!),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double toY, Color color, double width, double widthTouched) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: toY,
          color: color,
          width: touchedIndex == x ? widthTouched : width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 80,
            color: const Color.fromRGBO(158, 158, 158, 0.1),
          ),
        ),
      ],
      showingTooltipIndicators: touchedIndex == x ? [0] : [],
    );
  }

  Widget _buildLegendItem(String label, Color color, double percentage) {
    return Column(
      children: [
        Container(
          width: sizing.isVerySmall ? 16 : 20,
          height: sizing.isVerySmall ? 16 : 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(color.r.toInt(), color.g.toInt(), color.b.toInt(), 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: sizing.bottomNavLabelSize + 1,
            fontWeight: FontWeight.w600,
            color: _bpsTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: sizing.bottomNavLabelSize,
            fontWeight: FontWeight.w500,
            color: _bpsTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SectorAnalysis extends StatelessWidget {
  final int year;
  final Map<int, Map<String, dynamic>> indikatorData;
  final ResponsiveSizing sizing;

  const _SectorAnalysis({
    required this.year,
    required this.indikatorData,
    required this.sizing,
  });

  static const Map<int, double> _dependencyRatio = {
    2020: 28.52,
    2021: 28.59,
    2022: 28.68,
    2023: 28.77,
    2024: 28.91,
  };

  @override
  Widget build(BuildContext context) {
    if (!indikatorData.containsKey(year)) {
      return Container(
        padding: EdgeInsets.all(sizing.statsCardPadding),
        decoration: BoxDecoration(
          color: _bpsCardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('Data indikator tidak tersedia')),
      );
    }

    final indikator = indikatorData[year]!;

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bpsBorder),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
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
              fontSize: sizing.sectionTitleSize - 2,
              fontWeight: FontWeight.bold,
              color: _bpsTextPrimary,
            ),
          ),
          SizedBox(height: sizing.itemSpacing + 3),
          _buildAnalysisItem(
            'Tingkat Pengangguran Terbuka (TPT)',
            '${indikator['tptTotal']}%',
            'Laki-laki: ${indikator['tptLaki']}% | Perempuan: ${indikator['tptPerempuan']}%',
            Icons.trending_down,
            _bpsRed,
          ),
          SizedBox(height: sizing.itemSpacing),
          _buildAnalysisItem(
            'Tingkat Partisipasi Angkatan Kerja (TPAK)',
            '${indikator['tpakTotal']}%',
            'Laki-laki: ${indikator['tpakLaki']}% | Perempuan: ${indikator['tpakPerempuan']}%',
            Icons.trending_up,
            _bpsBlue,
          ),
          SizedBox(height: sizing.itemSpacing),
          _buildAnalysisItem(
            'Tingkat Kesempatan Kerja (TKK)',
            '${indikator['tkkTotal']}%',
            'Laki-laki: ${indikator['tkkLaki']}% | Perempuan: ${indikator['tkkPerempuan']}%',
            Icons.work_outline,
            _bpsGreen,
          ),
          if (_dependencyRatio.containsKey(year)) ...[
            SizedBox(height: sizing.itemSpacing),
            _buildAnalysisItem(
              'Angka Ketergantungan',
              '${_dependencyRatio[year]!.toStringAsFixed(2)}',
              'Rasio ketergantungan penduduk Kota Semarang',
              Icons.info_outline,
              _bpsPurple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String value, String description,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(sizing.itemSpacing + 2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.r.toInt(), color.g.toInt(), color.b.toInt(), 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromRGBO(color.r.toInt(), color.g.toInt(), color.b.toInt(), 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sizing.itemSpacing - 2),
            decoration: BoxDecoration(
              color: Color.fromRGBO(color.r.toInt(), color.g.toInt(), color.b.toInt(), 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: sizing.sectionIconSize),
          ),
          SizedBox(width: sizing.itemSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sizing.categoryLabelFontSize - 1,
                    fontWeight: FontWeight.bold,
                    color: _bpsTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: sizing.sectionTitleSize - 2,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: sizing.statsChangeFontSize + 1,
                    color: _bpsTextSecondary,
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
