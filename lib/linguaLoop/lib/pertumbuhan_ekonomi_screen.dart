import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ekonomi_data.dart';
import 'responsive_sizing.dart';

// BPS Color Palette
const Color _bpsBlue = Color(0xFF2E99D6);
const Color _bpsOrange = Color(0xFFE88D34);
const Color _bpsGreen = Color(0xFF7DBD42);
const Color _bpsBackground = Color(0xFFF5F5F5);
const Color _bpsCardBg = Color(0xFFFFFFFF);
const Color _bpsTextPrimary = Color(0xFF333333);
const Color _bpsTextSecondary = Color(0xFF808080);
const Color _bpsTextLabel = Color(0xFFA0A0A0);
const Color _bpsBorder = Color(0xFFE0E0E0);

class PertumbuhanEkonomiScreen extends StatefulWidget {
  const PertumbuhanEkonomiScreen({super.key});

  @override
  State<PertumbuhanEkonomiScreen> createState() => _PertumbuhanEkonomiScreenState();
}

class _PertumbuhanEkonomiScreenState extends State<PertumbuhanEkonomiScreen> {
  final dataManager = EkonomiDataManager();
  late int selectedYear;
  late List<int> availableYears;
  late Timer _debounceTimer;

  @override
  void initState() {
    super.initState();
    availableYears = dataManager.getAvailableYears()..sort();
    selectedYear = availableYears.isNotEmpty ? availableYears.last : 2024;
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {});
  }

  @override
  void dispose() {
    _debounceTimer.cancel();
    super.dispose();
  }

  void _changeYear(int year) {
    // Debounce year changes for performance
    _debounceTimer.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          selectedYear = year;
        });
      }
    });
  }

  EkonomiData? get currentData => dataManager.getDataByYear(selectedYear.toString());

  @override
  Widget build(BuildContext context) {
    final sizing = ResponsiveSizing(context);
    final isSmallScreen = sizing.isVerySmall || sizing.isSmall;

    if (availableYears.isEmpty || currentData == null) {
      return Scaffold(
        backgroundColor: _bpsBackground,
        body: Column(
          children: [
            _buildHeader(context, sizing, isSmallScreen),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(sizing.horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: isSmallScreen ? 48 : 64,
                        color: _bpsTextLabel,
                      ),
                      SizedBox(height: sizing.horizontalPadding),
                      Text(
                        'Belum ada data tersedia',
                        style: TextStyle(
                          fontSize: isSmallScreen 
                              ? sizing.sectionTitleSize - 2 
                              : sizing.sectionTitleSize,
                          color: _bpsTextSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bpsBackground,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, sizing, isSmallScreen)),
          SliverPadding(
            padding: EdgeInsets.all(sizing.horizontalPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildYearSelector(sizing, isSmallScreen),
                SizedBox(height: sizing.sectionSpacing),
                _buildMainIndicators(sizing, isSmallScreen),
                SizedBox(height: sizing.sectionSpacing),
                _buildPDRBSection(sizing, isSmallScreen),
                SizedBox(height: sizing.sectionSpacing),
                _buildChartSection(sizing, isSmallScreen),
                SizedBox(height: sizing.sectionSpacing),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveSizing sizing, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: _bpsBlue,
        boxShadow: [
          BoxShadow(
            color: _bpsBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(sizing.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button
              Row(
                children: [
                  Material(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: isSmallScreen ? 20 : 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sizing.itemSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pertumbuhan Ekonomi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen 
                                ? sizing.headerTitleSize - 2 
                                : sizing.headerTitleSize,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 4),
                        Text(
                          'Data Tahun $selectedYear',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isSmallScreen 
                                ? sizing.headerSubtitleSize - 2 
                                : sizing.headerSubtitleSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSelector(ResponsiveSizing sizing, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen 
          ? sizing.statsCardPadding - 4 
          : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: _bpsBlue,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: isSmallScreen 
                      ? sizing.groupTitleSize - 2 
                      : sizing.groupTitleSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Wrap(
            spacing: isSmallScreen ? 8 : 12,
            runSpacing: isSmallScreen ? 8 : 12,
            children: availableYears.map((year) {
              final isSelected = year == selectedYear;
              return Material(
                color: isSelected ? _bpsBlue : _bpsBackground,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _changeYear(year),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: isSmallScreen ? 60 : 70,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 8 : 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? _bpsBlue : _bpsBorder,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : _bpsTextSecondary,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildMainIndicators(ResponsiveSizing sizing, bool isSmallScreen) {
    final data = currentData!;
    final iconSize = isSmallScreen ? 24 : 28;
    final fontSize = isSmallScreen ? 14 : 16;

    return Container(
      padding: EdgeInsets.all(isSmallScreen 
          ? sizing.statsCardPadding - 4 
          : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: _bpsBlue,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Text(
                  'Indikator Utama Ekonomi',
                  style: TextStyle(
                    fontSize: isSmallScreen 
                        ? sizing.groupTitleSize - 2 
                        : sizing.groupTitleSize,
                    fontWeight: FontWeight.w700,
                    color: _bpsTextPrimary,
                  ),
                ),
              ),
              if (!isSmallScreen) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizing.itemSpacing,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _bpsBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: _bpsBlue,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap untuk detail',
                        style: TextStyle(
                          fontSize: 12,
                          color: _bpsBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          sizing.isVerySmall
              ? Column(
                  children: [
                    _buildIndicatorCard(
                      sizing: sizing,
                      value: data.pertumbuhanEkonomi,
                      label: 'Pertumbuhan Ekonomi',
                      icon: Icons.trending_up_rounded,
                      color: _bpsBlue,
                      isSmallScreen: isSmallScreen,
                      onTap: () => _showDetailDialog(
                        'Pertumbuhan Ekonomi',
                        data.pertumbuhanEkonomi,
                        Icons.trending_up_rounded,
                        _bpsBlue,
                        'Pertumbuhan ekonomi menunjukkan peningkatan aktivitas ekonomi dalam periode tertentu. Angka positif menandakan ekonomi sedang berkembang.',
                        data,
                        sizing,
                        isSmallScreen,
                      ),
                    ),
                    SizedBox(height: sizing.gridSpacing),
                    _buildIndicatorCard(
                      sizing: sizing,
                      value: data.kontribusiPDRB,
                      label: 'Kontribusi PDRB',
                      icon: Icons.pie_chart_rounded,
                      color: _bpsGreen,
                      isSmallScreen: isSmallScreen,
                      onTap: () => _showDetailDialog(
                        'Kontribusi PDRB',
                        data.kontribusiPDRB,
                        Icons.pie_chart_rounded,
                        _bpsGreen,
                        'Kontribusi PDRB menunjukkan seberapa besar peran wilayah ini terhadap produk domestik regional bruto.',
                        data,
                        sizing,
                        isSmallScreen,
                      ),
                    ),
                    SizedBox(height: sizing.gridSpacing),
                    _buildIndicatorCard(
                      sizing: sizing,
                      value: data.sektorPerdagangan,
                      label: 'Sektor Perdagangan',
                      icon: Icons.store_rounded,
                      color: _bpsOrange,
                      isSmallScreen: isSmallScreen,
                      onTap: () => _showDetailDialog(
                        'Sektor Perdagangan',
                        data.sektorPerdagangan,
                        Icons.store_rounded,
                        _bpsOrange,
                        'Sektor perdagangan merupakan salah satu penopang ekonomi utama wilayah.',
                        data,
                        sizing,
                        isSmallScreen,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildIndicatorCard(
                        sizing: sizing,
                        value: data.pertumbuhanEkonomi,
                        label: 'Pertumbuhan Ekonomi',
                        icon: Icons.trending_up_rounded,
                        color: _bpsBlue,
                        isSmallScreen: isSmallScreen,
                        onTap: () => _showDetailDialog(
                          'Pertumbuhan Ekonomi',
                          data.pertumbuhanEkonomi,
                          Icons.trending_up_rounded,
                          _bpsBlue,
                          'Pertumbuhan ekonomi menunjukkan peningkatan aktivitas ekonomi dalam periode tertentu. Angka positif menandakan ekonomi sedang berkembang.',
                          data,
                          sizing,
                          isSmallScreen,
                        ),
                      ),
                    ),
                    SizedBox(width: sizing.gridSpacing),
                    Expanded(
                      child: _buildIndicatorCard(
                        sizing: sizing,
                        value: data.kontribusiPDRB,
                        label: 'Kontribusi PDRB',
                        icon: Icons.pie_chart_rounded,
                        color: _bpsGreen,
                        isSmallScreen: isSmallScreen,
                        onTap: () => _showDetailDialog(
                          'Kontribusi PDRB',
                          data.kontribusiPDRB,
                          Icons.pie_chart_rounded,
                          _bpsGreen,
                          'Kontribusi PDRB menunjukkan seberapa besar peran wilayah ini terhadap produk domestik regional bruto.',
                          data,
                          sizing,
                          isSmallScreen,
                        ),
                      ),
                    ),
                    SizedBox(width: sizing.gridSpacing),
                    Expanded(
                      child: _buildIndicatorCard(
                        sizing: sizing,
                        value: data.sektorPerdagangan,
                        label: 'Sektor Perdagangan',
                        icon: Icons.store_rounded,
                        color: _bpsOrange,
                        isSmallScreen: isSmallScreen,
                        onTap: () => _showDetailDialog(
                          'Sektor Perdagangan',
                          data.sektorPerdagangan,
                          Icons.store_rounded,
                          _bpsOrange,
                          'Sektor perdagangan merupakan salah satu penopang ekonomi utama wilayah.',
                          data,
                          sizing,
                          isSmallScreen,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard({
    required ResponsiveSizing sizing,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _bpsCardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 4 : 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: _bpsTextSecondary,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: color.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Detail',
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(
    String title,
    String value,
    IconData icon,
    Color color,
    String description,
    EkonomiData data,
    ResponsiveSizing sizing,
    bool isSmallScreen,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final dialogSizing = ResponsiveSizing(dialogContext);
        final isDialogSmall = dialogSizing.isVerySmall || dialogSizing.isSmall;
        
        return Dialog(
          insetPadding: EdgeInsets.all(isDialogSmall ? 12 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.85,
              maxWidth: isDialogSmall 
                  ? MediaQuery.of(dialogContext).size.width - 24 
                  : 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(isDialogSmall ? 12 : 16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDialogSmall ? 8 : 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: isDialogSmall ? 20 : 24,
                        ),
                      ),
                      SizedBox(width: isDialogSmall ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: isDialogSmall ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tahun ${data.tahun}',
                              style: TextStyle(
                                fontSize: isDialogSmall ? 12 : 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => Navigator.pop(dialogContext),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: isDialogSmall ? 18 : 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isDialogSmall ? 12 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Value Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isDialogSmall ? 12 : 16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: color.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Nilai Indikator',
                                style: TextStyle(
                                  fontSize: isDialogSmall ? 13 : 14,
                                  color: _bpsTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: isDialogSmall ? 8 : 12),
                              Text(
                                value,
                                style: TextStyle(
                                  fontSize: isDialogSmall ? 28 : 32,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isDialogSmall ? 12 : 16),

                        // Description
                        Container(
                          padding: EdgeInsets.all(isDialogSmall ? 12 : 16),
                          decoration: BoxDecoration(
                            color: _bpsBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: color,
                                size: isDialogSmall ? 18 : 20,
                              ),
                              SizedBox(width: isDialogSmall ? 8 : 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Penjelasan',
                                      style: TextStyle(
                                        fontSize: isDialogSmall ? 14 : 16,
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                      ),
                                    ),
                                    SizedBox(height: isDialogSmall ? 4 : 6),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: isDialogSmall ? 13 : 14,
                                        color: _bpsTextSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isDialogSmall ? 12 : 16),

                        // Mini Chart
                        Container(
                          height: isDialogSmall ? 150 : 180,
                          padding: EdgeInsets.all(isDialogSmall ? 8 : 12),
                          decoration: BoxDecoration(
                            color: _bpsCardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _bpsBorder),
                          ),
                          child: _buildMiniChart(data, color, isDialogSmall),
                        ),

                        SizedBox(height: isDialogSmall ? 12 : 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniChart(EkonomiData data, Color color, bool isSmall) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: _bpsBorder,
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isSmall ? 25 : 32,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: isSmall ? 10 : 12,
                      color: _bpsTextSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.semarangData.length) {
                  final year = data.semarangData[index].year;
                  final label = isSmall
                      ? "'${year.toString().substring(2)}"
                      : year.toString();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: isSmall ? 10 : 12,
                        color: _bpsTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.semarangData.length - 1).toDouble(),
        minY: 0,
        maxY: ((data.semarangData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2) / 10).ceil() * 10.0,
        lineBarsData: [
          LineChartBarData(
            spots: data.semarangData.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.value);
            }).toList(),
            isCurved: true,
            color: color,
            barWidth: isSmall ? 2 : 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: isSmall ? false : true, // Hide dots on small screens
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: isSmall ? 2 : 3,
                  color: color,
                  strokeWidth: isSmall ? 1 : 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPDRBSection(ResponsiveSizing sizing, bool isSmallScreen) {
    final data = currentData!;

    return Container(
      padding: EdgeInsets.all(isSmallScreen 
          ? sizing.statsCardPadding - 4 
          : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _bpsBlue,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'PDRB per Kapita',
                style: TextStyle(
                  fontSize: isSmallScreen 
                      ? sizing.groupTitleSize - 2 
                      : sizing.groupTitleSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Main PDRB Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: _bpsBlue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _bpsBlue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Nilai PDRB per Kapita',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  data.pdrbPerKapita,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: isSmallScreen ? 14 : 16,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Text(
                        'Tahun ${data.tahun}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Comparison cards
          Row(
            children: [
              Expanded(
                child: _buildPDRBComparisonCard(
                  value: data.vsJawaTengah,
                  label: 'vs Jawa Tengah',
                  icon: Icons.compare_arrows_rounded,
                  color: _bpsGreen,
                  isSmallScreen: isSmallScreen,
                ),
              ),
              SizedBox(width: sizing.gridSpacing),
              Expanded(
                child: _buildPDRBComparisonCard(
                  value: data.vsNasional,
                  label: 'vs Nasional',
                  icon: Icons.public_rounded,
                  color: _bpsOrange,
                  isSmallScreen: isSmallScreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPDRBComparisonCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: _bpsTextSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(ResponsiveSizing sizing, bool isSmallScreen) {
    final data = currentData!;
    final double chartHeight = isSmallScreen ? 180 : 220;

    return Container(
      padding: EdgeInsets.all(isSmallScreen 
          ? sizing.statsCardPadding - 4 
          : sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: _bpsBlue,
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafik Pertumbuhan Ekonomi',
                      style: TextStyle(
                        fontSize: isSmallScreen 
                            ? sizing.groupTitleSize - 2 
                            : sizing.groupTitleSize,
                        fontWeight: FontWeight.w700,
                        color: _bpsTextPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Perbandingan Dua Wilayah (Pertumbuhan %)',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: _bpsTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Legend
          Wrap(
            spacing: isSmallScreen ? 8 : 12,
            runSpacing: isSmallScreen ? 8 : 12,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem('Kota Semarang', _bpsBlue, isSmallScreen),
              _buildLegendItem('Provinsi Jawa Tengah', _bpsGreen, isSmallScreen),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Chart
          SizedBox(
            height: chartHeight,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: _bpsBorder,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isSmallScreen ? 28 : 35,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: _bpsTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.semarangData.length) {
                          final year = data.semarangData[index].year;
                          final label = sizing.isVerySmall
                              ? "'${year.toString().substring(2)}"
                              : year.toString();
                          return Padding(
                            padding: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: _bpsTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.semarangData.length - 1).toDouble(),
                minY: 0,
                maxY: (([
                  ...data.semarangData.map((e) => e.value),
                  ...data.jatengData.map((e) => e.value),
                ].reduce((a, b) => a > b ? a : b) * 1.2) / 10).ceil() * 10.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.semarangData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.value);
                    }).toList(),
                    isCurved: true,
                    color: _bpsBlue,
                    barWidth: isSmallScreen ? 2.5 : 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: !isSmallScreen,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: isSmallScreen ? 3 : 4,
                          color: _bpsBlue,
                          strokeWidth: isSmallScreen ? 1.5 : 2.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _bpsBlue.withOpacity(0.15),
                          _bpsBlue.withOpacity(0.01),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: data.jatengData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.value);
                    }).toList(),
                    isCurved: true,
                    color: _bpsGreen,
                    barWidth: isSmallScreen ? 2.5 : 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: !isSmallScreen,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: isSmallScreen ? 3 : 4,
                          color: _bpsGreen,
                          strokeWidth: isSmallScreen ? 1.5 : 2.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _bpsGreen.withOpacity(0.15),
                          _bpsGreen.withOpacity(0.01),
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
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 12,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmallScreen ? 8 : 10,
            height: isSmallScreen ? 8 : 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}