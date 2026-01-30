import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'responsive_sizing.dart';

// BPS Color Palette
const Color _bpsBlue = Color(0xFF2E99D6);
const Color _bpsOrange = Color(0xFFE88D34);
const Color _bpsGreen = Color(0xFF7DBD42);
const Color _bpsRed = Color(0xFFEF4444);
const Color _bpsBackground = Color(0xFFF5F5F5);
const Color _bpsCardBg = Color(0xFFFFFFFF);
const Color _bpsTextPrimary = Color(0xFF333333);
const Color _bpsTextSecondary = Color(0xFF808080);
const Color _bpsBorder = Color(0xFFE0E0E0);

class IDGData {
  final int year;
  final double? sumbangan;
  final double? tenaga;
  final double? parlemen;
  final double? idg;
  final double? ikg;

  IDGData({
    required this.year,
    this.sumbangan,
    this.tenaga,
    this.parlemen,
    this.idg,
    this.ikg,
  });

  String get idgFormatted => idg != null ? idg!.toStringAsFixed(2) : 'N/A';
  String get ikgFormatted => ikg != null ? ikg!.toStringAsFixed(2) : 'N/A';
  String get sumbanganFormatted => sumbangan != null ? sumbangan!.toStringAsFixed(2) : 'N/A';
  String get tenagaFormatted => tenaga != null ? tenaga!.toStringAsFixed(2) : 'N/A';
  String get parlemenFormatted => parlemen != null ? parlemen!.toStringAsFixed(2) : 'N/A';
}

class IDGScreen extends StatefulWidget {
  const IDGScreen({super.key});

  @override
  State<IDGScreen> createState() => _IDGScreenState();
}

class _IDGScreenState extends State<IDGScreen> {
  Map<int, IDGData> idgDataByYear = {};
  List<int> availableYears = [];
  int selectedYear = 2024;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIDGData();
  }

  Future<void> _loadIDGData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedData = prefs.getString('idg_data');
      
      Map<int, IDGData> processedData = {};
      
      if (savedData != null) {
        Map<String, dynamic> decoded = json.decode(savedData);
        decoded.forEach((key, value) {
          final int year = int.parse(key);
          final Map<String, dynamic> data = value as Map<String, dynamic>;
          processedData[year] = IDGData(
            year: year,
            sumbangan: data['sumbangan'] as double?,
            tenaga: data['tenaga'] as double?,
            parlemen: data['parlemen'] as double?,
            idg: data['idg'] as double?,
            ikg: data['ikg'] as double?,
          );
        });
      } else {
        final List<Map<String, dynamic>> rawData = [
          {"Tahun": 2020, "SUMBANGAN": 37.13, "TENAGA": 51.15, "PARLEMEN": 20.41, "IDG": 74.67, "IKG": 0.157},
          {"Tahun": 2021, "SUMBANGAN": 37.46, "TENAGA": 51.30, "PARLEMEN": 18.75, "IDG": 73.64, "IKG": 0.142},
          {"Tahun": 2022, "SUMBANGAN": 38.05, "TENAGA": 49.78, "PARLEMEN": 18.00, "IDG": 73.93, "IKG": 0.266},
          {"Tahun": 2023, "SUMBANGAN": 37.93, "TENAGA": 48.76, "PARLEMEN": 18.00, "IDG": 73.86, "IKG": 0.168},
          {"Tahun": 2024, "SUMBANGAN": 37.68, "TENAGA": 50.42, "PARLEMEN": 24.00, "IDG": 78.71, "IKG": 0.14},
        ];

        for (var row in rawData) {
          final int year = row["Tahun"] as int;
          processedData[year] = IDGData(
            year: year,
            sumbangan: row["SUMBANGAN"] as double?,
            tenaga: row["TENAGA"] as double?,
            parlemen: row["PARLEMEN"] as double?,
            idg: row["IDG"] as double?,
            ikg: row["IKG"] as double?,
          );
        }
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            idgDataByYear = processedData;
            availableYears = processedData.keys.toList()..sort();
            if (availableYears.isNotEmpty) {
              selectedYear = availableYears.last;
            }
            isLoading = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error loading IDG data: $e');
      setState(() => isLoading = false);
    }
  }

  IDGData get currentIDGData {
    if (idgDataByYear.isEmpty) return IDGData(year: selectedYear);
    return idgDataByYear[selectedYear] ?? idgDataByYear[availableYears.last]!;
  }

  @override
  Widget build(BuildContext context) {
    final sizing = ResponsiveSizing(context);
    final isSmallScreen = sizing.isVerySmall || sizing.isSmall;

    if (isLoading) {
      return Scaffold(
        backgroundColor: _bpsBackground,
        body: Column(
          children: [
            _buildHeader(context, sizing, isSmallScreen),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: _bpsOrange),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bpsBackground,
      body: Column(
        children: [
          _buildHeader(context, sizing, isSmallScreen),
          Expanded(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(sizing.horizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildYearSelector(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                      _buildIDGMainCard(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                      _buildIDGStats(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                      _buildIDGOnlyChart(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                      _buildIKGOnlyChart(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                      _buildIDGDescription(sizing, isSmallScreen),
                      SizedBox(height: sizing.sectionSpacing),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveSizing sizing, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: _bpsOrange,
        boxShadow: [BoxShadow(color: _bpsOrange.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(sizing.horizontalPadding),
          child: Row(
            children: [
              Material(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: isSmallScreen ? 20 : 24),
                  ),
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Indeks Pemberdayaan Gender', style: TextStyle(color: Colors.white, fontSize: isSmallScreen ? sizing.headerTitleSize - 2 : sizing.headerTitleSize, fontWeight: FontWeight.w700, height: 1.1), maxLines: 2, overflow: TextOverflow.ellipsis),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text('Data Tahun $selectedYear', style: TextStyle(color: Colors.white70, fontSize: isSmallScreen ? sizing.headerSubtitleSize - 2 : sizing.headerSubtitleSize)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.groups_rounded, color: Colors.white, size: isSmallScreen ? 20 : 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSelector(ResponsiveSizing sizing, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.calendar_today_rounded, color: _bpsOrange, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Text('Pilih Tahun Data', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableYears.map((year) {
                final isSelected = year == selectedYear;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedYear = year),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20, vertical: isSmallScreen ? 10 : 12),
                      decoration: BoxDecoration(
                        color: isSelected ? _bpsOrange : _bpsBackground,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected ? [BoxShadow(color: _bpsOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                      ),
                      child: Text(year.toString(), style: TextStyle(color: isSelected ? Colors.white : _bpsTextSecondary, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, fontSize: isSmallScreen ? 13 : 14)),
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

  Widget _buildIDGMainCard(ResponsiveSizing sizing, bool isSmallScreen) {
    final data = currentIDGData;
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.bar_chart_rounded, color: _bpsGreen, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Text('Indeks Utama', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Row(
            children: [
              Expanded(child: _buildMainIndexCard('IDG', data.idgFormatted, 'Pemberdayaan Gender', Icons.groups, _bpsOrange, isSmallScreen)),
              const SizedBox(width: 12),
              Expanded(child: _buildMainIndexCard('IKG', data.ikgFormatted, 'Ketimpangan Gender', Icons.balance, _bpsBlue, isSmallScreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainIndexCard(String title, String value, String subtitle, IconData icon, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: isSmallScreen ? 18 : 20)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: isSmallScreen ? 18 : 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: isSmallScreen ? 12 : 13, color: _bpsTextPrimary, fontWeight: FontWeight.w600)),
          Text(subtitle, style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildIDGStats(ResponsiveSizing sizing, bool isSmallScreen) {
    final data = currentIDGData;
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.analytics_outlined, color: _bpsBlue, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Text('Komponen IDG', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildStatItem('Sumbangan Pendapatan Perempuan', '${data.sumbanganFormatted}%', 'Kontribusi Ekonomi Perempuan', Icons.attach_money, _bpsOrange, isSmallScreen),
          const SizedBox(height: 12),
          _buildStatItem('Perempuan sebagai Tenaga Profesional', '${data.tenagaFormatted}%', 'Profesional dan Teknis', Icons.business_center, _bpsBlue, isSmallScreen),
          const SizedBox(height: 12),
          _buildStatItem('Keterlibatan Perempuan di Parlemen', '${data.parlemenFormatted}%', 'Partisipasi Politik', Icons.account_balance, _bpsGreen, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, String subtitle, IconData icon, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.15))),
      child: Row(
        children: [
          Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: isSmallScreen ? 18 : 20, fontWeight: FontWeight.bold, color: color)),
                Text(title, style: TextStyle(fontSize: isSmallScreen ? 11 : 12, fontWeight: FontWeight.w600, color: _bpsTextPrimary)),
                Text(subtitle, style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIDGOnlyChart(ResponsiveSizing sizing, bool isSmallScreen) {
    List<FlSpot> idgSpots = [];
    List<String> yearLabels = [];

    for (int i = 0; i < availableYears.length; i++) {
      final year = availableYears[i];
      final data = idgDataByYear[year];
      if (data?.idg != null) {
        idgSpots.add(FlSpot(i.toDouble(), data!.idg!));
        yearLabels.add(year.toString());
      }
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(color: _bpsCardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.trending_up, color: _bpsOrange, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tren IDG', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)), Text('Nilai lebih tinggi = lebih baik', style: TextStyle(fontSize: isSmallScreen ? 10 : 11, color: _bpsOrange))])),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          SizedBox(
            height: 220,
            child: idgSpots.isNotEmpty
                ? LineChart(
                    LineChartData(
                      minY: 64, maxY: 80,
                      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2, getDrawingHorizontalLine: (value) => FlLine(color: _bpsBorder, strokeWidth: 0.5)),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, interval: 4, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary)))),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: (value, meta) { final index = value.toInt(); if (index >= 0 && index < yearLabels.length) { return Padding(padding: const EdgeInsets.only(top: 8), child: Text(yearLabels[index], style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary))); } return const Text(''); })),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(spots: idgSpots, isCurved: true, color: _bpsOrange, barWidth: 3, dotData: const FlDotData(show: true), belowBarData: BarAreaData(show: true, color: _bpsOrange.withOpacity(0.15))),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
                            final index = barSpot.x.toInt();
                            if (index >= 0 && index < yearLabels.length) {
                              return LineTooltipItem('${yearLabels[index]}\nIDG: ${barSpot.y.toStringAsFixed(2)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11));
                            }
                            return null;
                          }).whereType<LineTooltipItem>().toList(),
                        ),
                      ),
                    ),
                  )
                : Center(child: Text('Data tidak tersedia', style: TextStyle(color: _bpsTextSecondary))),
          ),
        ],
      ),
    );
  }

  Widget _buildIKGOnlyChart(ResponsiveSizing sizing, bool isSmallScreen) {
    List<FlSpot> ikgSpots = [];
    List<String> yearLabels = [];

    for (int i = 0; i < availableYears.length; i++) {
      final year = availableYears[i];
      final data = idgDataByYear[year];
      if (data?.ikg != null) {
        ikgSpots.add(FlSpot(i.toDouble(), data!.ikg!));
        yearLabels.add(year.toString());
      }
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(color: _bpsCardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.trending_down, color: _bpsBlue, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tren IKG (Ketimpangan)', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)), Text('Nilai lebih rendah = lebih baik', style: TextStyle(fontSize: isSmallScreen ? 10 : 11, color: _bpsBlue))])),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          SizedBox(
            height: 220,
            child: ikgSpots.isNotEmpty
                ? LineChart(
                    LineChartData(
                      minY: 0, maxY: 0.35,
                      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 0.05, getDrawingHorizontalLine: (value) => FlLine(color: _bpsBorder, strokeWidth: 0.5)),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, interval: 0.1, getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(2), style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary)))),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: (value, meta) { final index = value.toInt(); if (index >= 0 && index < yearLabels.length) { return Padding(padding: const EdgeInsets.only(top: 8), child: Text(yearLabels[index], style: TextStyle(fontSize: isSmallScreen ? 9 : 10, color: _bpsTextSecondary))); } return const Text(''); })),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(spots: ikgSpots, isCurved: true, color: _bpsBlue, barWidth: 3, dotData: const FlDotData(show: true), belowBarData: BarAreaData(show: true, color: _bpsBlue.withOpacity(0.15))),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
                            final index = barSpot.x.toInt();
                            if (index >= 0 && index < yearLabels.length) {
                              return LineTooltipItem('${yearLabels[index]}\nIKG: ${barSpot.y.toStringAsFixed(3)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11));
                            }
                            return null;
                          }).whereType<LineTooltipItem>().toList(),
                        ),
                      ),
                    ),
                  )
                : Center(child: Text('Data tidak tersedia', style: TextStyle(color: _bpsTextSecondary))),
          ),
        ],
      ),
    );
  }

  Widget _buildIDGDescription(ResponsiveSizing sizing, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? sizing.statsCardPadding - 4 : sizing.statsCardPadding),
      decoration: BoxDecoration(color: _bpsCardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: EdgeInsets.all(isSmallScreen ? 8 : 10), decoration: BoxDecoration(color: _bpsGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.info_outline_rounded, color: _bpsGreen, size: isSmallScreen ? 16 : 18)),
              SizedBox(width: sizing.itemSpacing),
              Text('Tentang IDG & IKG', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w700, color: _bpsTextPrimary)),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildDescriptionItem('IDG (Indeks Pemberdayaan Gender)', 'Mengukur kesetaraan peran antara laki-laki dan perempuan dalam bidang ekonomi, politik, dan pengambilan keputusan.', _bpsOrange, isSmallScreen),
          const SizedBox(height: 12),
          _buildDescriptionItem('IKG (Indeks Ketimpangan Gender)', 'Mengukur ketidaksetaraan pencapaian antara laki-laki dan perempuan dalam kesehatan reproduksi, pemberdayaan, dan pasar tenaga kerja.', _bpsBlue, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildDescriptionItem(String title, String description, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: isSmallScreen ? 12 : 13, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: isSmallScreen ? 10 : 11, color: _bpsTextSecondary, height: 1.4)),
        ],
      ),
    );
  }
}