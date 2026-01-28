import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'responsive_sizing.dart';

// BPS Color Palette - Consistent with home_screen.dart
const Color _bpsBlue = Color(0xFF2E99D6);
const Color _bpsOrange = Color(0xFFE88D34);
const Color _bpsGreen = Color(0xFF7DBD42);
const Color _bpsBackground = Color(0xFFF5F5F5);
const Color _bpsCardBg = Color(0xFFFFFFFF);
const Color _bpsTextPrimary = Color(0xFF333333);
const Color _bpsTextSecondary = Color(0xFF808080);
const Color _bpsTextLabel = Color(0xFFA0A0A0);
const Color _bpsBorder = Color(0xFFE0E0E0);
const Color _bpsRed = Color(0xFFE05555);
const Color _bpsPurple = Color(0xFF9B59B6);
const Color _bpsTeal = Color(0xFF1ABC9C);

class InflasiScreen extends StatefulWidget {
  const InflasiScreen({super.key});

  @override
  State<InflasiScreen> createState() => _InflasiScreenState();
}

class _InflasiScreenState extends State<InflasiScreen> {
  int selectedYear = 2023;
  int? selectedMonth;

  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final List<String> fullMonths = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  // Data inflasi bulanan
  final Map<int, List<double>> monthlyInflationData = {
    2019: [0.32, 0.01, 0.11, -0.10, 0.48, 0.55, 0.31, -0.02, -0.27, 0.02, -0.16, 0.30],
    2020: [0.40, 0.28, 0.10, -0.10, 0.07, 0.18, -0.05, -0.05, -0.05, -0.09, 0.28, 0.45],
    2021: [0.26, 0.10, 0.08, -0.13, 0.32, 0.33, 0.21, 0.03, 0.12, 0.12, 0.37, 0.57],
    2022: [0.56, 0.64, 0.66, 0.95, 0.40, 0.56, 0.64, 0.21, 1.17, 0.12, 0.03, 0.66],
    2023: [0.34, -0.02, 0.12, -0.07, 0.09, 0.59, 0.21, 0.18, -0.04, -0.06, 0.08, 0.15],
  };

  // Data inflasi tahunan
  final Map<int, double> yearlyInflation = {
    2019: 2.72,
    2020: 1.68,
    2021: 1.87,
    2022: 4.21,
    2023: 2.61,
  };

  // Data inflasi inti
  final Map<int, double> coreInflation = {
    2019: 3.04,
    2020: 1.59,
    2021: 1.64,
    2022: 3.04,
    2023: 1.93,
  };

  // Data IHK
  final Map<int, double> ihkData = {
    2019: 106.02,
    2020: 107.80,
    2021: 109.82,
    2022: 114.44,
    2023: 113.59,
  };

  // Data komponen inflasi
  final Map<String, Map<String, double>> inflationComponents = {
    'Makanan, Minuman & Tembakau': {'2019': 4.55, '2020': 3.28, '2021': 2.84, '2022': 5.33, '2023': 4.12},
    'Pakaian & Alas Kaki': {'2019': 0.84, '2020': 0.45, '2021': 0.67, '2022': 1.23, '2023': 0.92},
    'Perumahan & Fasilitas': {'2019': 1.69, '2020': 1.45, '2021': 1.52, '2022': 2.15, '2023': 1.78},
    'Perawatan Kesehatan': {'2019': 2.43, '2020': 2.15, '2021': 2.67, '2022': 3.45, '2023': 2.89},
    'Transportasi': {'2019': 1.24, '2020': 0.89, '2021': 1.45, '2022': 4.67, '2023': 2.34},
    'Komunikasi & Keuangan': {'2019': 1.02, '2020': 0.78, '2021': 0.95, '2022': 1.34, '2023': 1.12},
    'Rekreasi & Olahraga': {'2019': 2.18, '2020': 1.67, '2021': 2.05, '2022': 2.89, '2023': 2.45},
  };

  // Getter methods
  List<int> get availableYears => monthlyInflationData.keys.toList()..sort();

  List<double> get filteredMonthlyData {
    if (selectedMonth == null) {
      return monthlyInflationData[selectedYear] ?? [];
    } else {
      return [monthlyInflationData[selectedYear]![selectedMonth!]];
    }
  }

  double get currentInflationValue {
    if (selectedMonth == null) {
      return monthlyInflationData[selectedYear]?.last ?? 0.0;
    } else {
      return monthlyInflationData[selectedYear]?[selectedMonth!] ?? 0.0;
    }
  }

  String get currentMonthLabel {
    if (selectedMonth == null) {
      return 'Desember';
    } else {
      return fullMonths[selectedMonth!];
    }
  }

  Color get inflationColor {
    final value = currentInflationValue;
    if (value > 0.5) return _bpsRed;
    if (value > 0.2) return _bpsOrange;
    if (value >= 0) return _bpsGreen;
    return _bpsBlue;
  }

  @override
  Widget build(BuildContext context) {
    final sizing = ResponsiveSizing(context);

    if (availableYears.isEmpty) {
      return Scaffold(
        backgroundColor: _bpsBackground,
        body: Column(
          children: [
            _buildHeader(context, sizing),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: sizing.isVerySmall ? 64 : 80,
                      color: _bpsTextLabel,
                    ),
                    SizedBox(height: sizing.horizontalPadding),
                    Text(
                      'Belum ada data tersedia',
                      style: TextStyle(
                        fontSize: sizing.sectionTitleSize,
                        color: _bpsTextSecondary,
                        fontWeight: FontWeight.w600,
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

    return Scaffold(
      backgroundColor: _bpsBackground,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, sizing)),
          SliverPadding(
            padding: EdgeInsets.all(sizing.horizontalPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildYearSelector(sizing),
                SizedBox(height: sizing.sectionSpacing),
                _buildMonthSelector(sizing),
                SizedBox(height: sizing.sectionSpacing),
                _buildMainIndicators(sizing),
                SizedBox(height: sizing.sectionSpacing),
                _buildInflationChart(sizing),
                SizedBox(height: sizing.sectionSpacing),
                _buildMonthlyInflationChart(sizing),
                SizedBox(height: sizing.sectionSpacing),
                _buildInflationComponents(sizing),
                SizedBox(height: sizing.sectionSpacing),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ResponsiveSizing sizing) {
    return Container(
      decoration: BoxDecoration(
        color: _bpsBlue,
        boxShadow: [
          BoxShadow(
            color: _bpsBlue.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
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
              Row(
                children: [
                  Material(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(sizing.headerLogoPadding),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: sizing.headerLogoSize,
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
                          'Data Inflasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sizing.headerTitleSize,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Data Tahun $selectedYear',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: sizing.headerSubtitleSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(sizing.headerLogoPadding),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.analytics_rounded,
                      color: Colors.white,
                      size: sizing.headerLogoSize,
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

  Widget _buildYearSelector(ResponsiveSizing sizing) {
    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: _bpsBlue,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: sizing.groupTitleSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          Wrap(
            spacing: sizing.itemSpacing,
            runSpacing: sizing.itemSpacing,
            children: availableYears.map((year) {
              final isSelected = year == selectedYear;
              return Material(
                color: isSelected ? _bpsBlue : _bpsBackground,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedYear = year;
                      selectedMonth = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizing.statsCardPadding,
                      vertical: sizing.itemSpacing,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _bpsBlue : _bpsBorder,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        fontSize: sizing.categoryLabelFontSize,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : _bpsTextSecondary,
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

  Widget _buildMonthSelector(ResponsiveSizing sizing) {
    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: _bpsOrange,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'Pilih Bulan',
                style: TextStyle(
                  fontSize: sizing.groupTitleSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
              const Spacer(),
              if (selectedMonth != null)
                Material(
                  color: _bpsOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => setState(() => selectedMonth = null),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizing.itemSpacing,
                        vertical: 4,
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: sizing.bottomNavLabelSize,
                          color: _bpsOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(months.length, (index) {
                final isSelected = selectedMonth == index;
                return Padding(
                  padding: EdgeInsets.only(right: sizing.itemSpacing),
                  child: Material(
                    color: isSelected ? _bpsOrange : _bpsBackground,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedMonth = isSelected ? null : index;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizing.statsCardPadding,
                          vertical: sizing.itemSpacing,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _bpsOrange : _bpsBorder,
                            width: isSelected ? 2 : 1.5,
                          ),
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            fontSize: sizing.categoryLabelFontSize,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : _bpsTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIndicators(ResponsiveSizing sizing) {
    final yearInflation = yearlyInflation[selectedYear] ?? 0.0;
    final coreInfl = coreInflation[selectedYear] ?? 0.0;
    final ihk = ihkData[selectedYear] ?? 0.0;

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: _bpsBlue,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Text(
                  'Indikator Utama Inflasi',
                  style: TextStyle(
                    fontSize: sizing.groupTitleSize,
                    fontWeight: FontWeight.w700,
                    color: _bpsTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizing.itemSpacing,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      color: _bpsBlue,
                      size: sizing.bottomNavLabelSize,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tap untuk detail',
                      style: TextStyle(
                        fontSize: sizing.bottomNavLabelSize,
                        color: _bpsBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          Row(
            children: [
              Expanded(
                child: _buildIndicatorCard(
                  sizing: sizing,
                  value: '${yearInflation.toStringAsFixed(2)}%',
                  label: 'Inflasi Tahunan',
                  icon: Icons.trending_up_rounded,
                  color: _bpsBlue,
                  onTap: () => _showDetailDialog(
                    'Inflasi Tahunan',
                    '${yearInflation.toStringAsFixed(2)}%',
                    Icons.trending_up_rounded,
                    _bpsBlue,
                    'Inflasi tahunan (Year-on-Year) mengukur perubahan harga barang dan jasa secara umum selama satu tahun. Angka ini menjadi acuan utama kebijakan moneter.',
                    sizing,
                  ),
                ),
              ),
              SizedBox(width: sizing.gridSpacing),
              Expanded(
                child: _buildIndicatorCard(
                  sizing: sizing,
                  value: '${currentInflationValue.toStringAsFixed(2)}%',
                  label: selectedMonth == null ? 'Inflasi Bulanan' : 'Inflasi $currentMonthLabel',
                  icon: Icons.calendar_month_rounded,
                  color: inflationColor,
                  onTap: () => _showDetailDialog(
                    selectedMonth == null ? 'Inflasi Bulanan' : 'Inflasi $currentMonthLabel',
                    '${currentInflationValue.toStringAsFixed(2)}%',
                    Icons.calendar_month_rounded,
                    inflationColor,
                    'Inflasi bulanan (Month-to-Month) mengukur perubahan harga barang dan jasa dari bulan ke bulan. Fluktuasi bulanan dipengaruhi oleh faktor musiman dan kebijakan harga.',
                    sizing,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.gridSpacing),
          Row(
            children: [
              Expanded(
                child: _buildIndicatorCard(
                  sizing: sizing,
                  value: '${coreInfl.toStringAsFixed(2)}%',
                  label: 'Inflasi Inti',
                  icon: Icons.insights_rounded,
                  color: _bpsGreen,
                  onTap: () => _showDetailDialog(
                    'Inflasi Inti',
                    '${coreInfl.toStringAsFixed(2)}%',
                    Icons.insights_rounded,
                    _bpsGreen,
                    'Inflasi inti (Core Inflation) menghilangkan komponen harga yang bergejolak (volatile) seperti bahan makanan dan energi. Indikator ini mencerminkan tekanan inflasi yang lebih fundamental.',
                    sizing,
                  ),
                ),
              ),
              SizedBox(width: sizing.gridSpacing),
              Expanded(
                child: _buildIndicatorCard(
                  sizing: sizing,
                  value: ihk.toStringAsFixed(2),
                  label: 'Indeks Harga Konsumen',
                  icon: Icons.assessment_rounded,
                  color: _bpsPurple,
                  onTap: () => _showDetailDialog(
                    'Indeks Harga Konsumen',
                    ihk.toStringAsFixed(2),
                    Icons.assessment_rounded,
                    _bpsPurple,
                    'Indeks Harga Konsumen (IHK) mengukur rata-rata perubahan harga dari suatu paket barang dan jasa yang dikonsumsi oleh rumah tangga. Basis perhitungan 2018=100.',
                    sizing,
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
    required VoidCallback onTap,
  }) {
    return Material(
      color: _bpsCardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(sizing.categoryCardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(sizing.categoryIconContainerPadding),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: sizing.categoryIconSize,
                ),
              ),
              SizedBox(height: sizing.itemSpacing),
              Text(
                value,
                style: TextStyle(
                  fontSize: sizing.statsValueFontSize,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sizing.itemSpacing - 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: sizing.categorySubLabelFontSize,
                  color: _bpsTextSecondary,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sizing.itemSpacing - 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: sizing.bottomNavLabelSize,
                    color: color.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: sizing.bottomNavLabelSize,
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
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

  Widget _buildInflationChart(ResponsiveSizing sizing) {
    final years = availableYears;
    final spots = years.asMap().entries.map((e) {
      final val = yearlyInflation[e.value] ?? 0.0;
      return FlSpot(e.key.toDouble(), val);
    }).toList();

    final maxY = (yearlyInflation.values.reduce((a, b) => a > b ? a : b) + 0.5).ceilToDouble();

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: _bpsBlue,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tren Inflasi Tahunan',
                      style: TextStyle(
                        fontSize: sizing.groupTitleSize,
                        fontWeight: FontWeight.w700,
                        color: _bpsTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Persentase Year-on-Year (${years.first}-${years.last})',
                      style: TextStyle(
                        fontSize: sizing.categorySubLabelFontSize,
                        color: _bpsTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: _bpsBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: sizing.bottomNavLabelSize,
                            color: _bpsTextSecondary,
                            fontWeight: FontWeight.w500,
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
                        if (index >= 0 && index < years.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              years[index].toString(),
                              style: TextStyle(
                                fontSize: sizing.bottomNavLabelSize,
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
                maxX: (years.length - 1).toDouble(),
                minY: 1.0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: _bpsBlue,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: _bpsBlue,
                          strokeWidth: 2.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _bpsBlue.withOpacity(0.2),
                          _bpsBlue.withOpacity(0.02),
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

  Widget _buildMonthlyInflationChart(ResponsiveSizing sizing) {
    if (filteredMonthlyData.isEmpty) {
      return Container(
        padding: EdgeInsets.all(sizing.statsCardPadding),
        decoration: BoxDecoration(
          color: _bpsCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _bpsBorder, width: 1.5),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.info_outline_rounded, size: 40, color: _bpsTextLabel),
              SizedBox(height: sizing.itemSpacing),
              Text(
                'Data tidak tersedia',
                style: TextStyle(
                  fontSize: sizing.categoryLabelFontSize,
                  color: _bpsTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final monthlyData = filteredMonthlyData;
    final maxValue = monthlyData.reduce((a, b) => a > b ? a : b) + 0.2;
    final minValue = monthlyData.reduce((a, b) => a < b ? a : b) - 0.2;

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: _bpsGreen,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedMonth == null
                          ? 'Inflasi Bulanan $selectedYear'
                          : 'Inflasi $currentMonthLabel $selectedYear',
                      style: TextStyle(
                        fontSize: sizing.groupTitleSize,
                        fontWeight: FontWeight.w700,
                        color: _bpsTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Persentase Month-to-Month',
                      style: TextStyle(
                        fontSize: sizing.categorySubLabelFontSize,
                        color: _bpsTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(sizing, 'Positif', _bpsBlue),
              SizedBox(width: sizing.horizontalPadding),
              _buildLegendItem(sizing, 'Negatif (Deflasi)', _bpsRed),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue,
                minY: minValue,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: sizing.bottomNavLabelSize,
                            color: _bpsTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (selectedMonth != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              months[selectedMonth!],
                              style: TextStyle(
                                fontSize: sizing.bottomNavLabelSize,
                                color: _bpsTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        } else {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                months[idx],
                                style: TextStyle(
                                  fontSize: sizing.bottomNavLabelSize,
                                  color: _bpsTextPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(monthlyData.length, (index) {
                  final value = monthlyData[index];
                  final color = value >= 0 ? _bpsBlue : _bpsRed;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: color,
                        width: selectedMonth != null ? 25 : 10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInflationComponents(ResponsiveSizing sizing) {
    final yearStr = selectedYear.toString();

    return Container(
      padding: EdgeInsets.all(sizing.statsCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bpsBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                padding: EdgeInsets.all(sizing.groupIconPadding),
                decoration: BoxDecoration(
                  color: _bpsOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: _bpsOrange,
                  size: sizing.groupIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing),
              Text(
                'Komponen Inflasi',
                style: TextStyle(
                  fontSize: sizing.groupTitleSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: sizing.horizontalPadding),
          ...inflationComponents.entries.map((entry) {
            final value = entry.value[yearStr] ?? 0.0;
            final color = _getComponentColor(entry.key);

            return Padding(
              padding: EdgeInsets.only(bottom: sizing.itemSpacing),
              child: Container(
                padding: EdgeInsets.all(sizing.statsCardPadding),
                decoration: BoxDecoration(
                  color: _bpsBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _bpsBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(sizing.categoryIconContainerPadding),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getComponentIcon(entry.key),
                        color: color,
                        size: sizing.groupIconSize,
                      ),
                    ),
                    SizedBox(width: sizing.itemSpacing),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: sizing.categoryLabelFontSize,
                          fontWeight: FontWeight.w600,
                          color: _bpsTextPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: sizing.itemSpacing),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizing.itemSpacing,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${value.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: sizing.categoryLabelFontSize,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ResponsiveSizing sizing, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizing.statsCardPadding,
        vertical: sizing.itemSpacing,
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
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: sizing.itemSpacing - 4),
          Text(
            label,
            style: TextStyle(
              fontSize: sizing.categorySubLabelFontSize,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getComponentColor(String component) {
    switch (component) {
      case 'Makanan, Minuman & Tembakau':
        return _bpsOrange;
      case 'Pakaian & Alas Kaki':
        return _bpsPurple;
      case 'Perumahan & Fasilitas':
        return _bpsBlue;
      case 'Perawatan Kesehatan':
        return _bpsRed;
      case 'Transportasi':
        return _bpsGreen;
      case 'Komunikasi & Keuangan':
        return const Color(0xFF3F51B5);
      case 'Rekreasi & Olahraga':
        return _bpsTeal;
      default:
        return _bpsTextSecondary;
    }
  }

  IconData _getComponentIcon(String component) {
    switch (component) {
      case 'Makanan, Minuman & Tembakau':
        return Icons.restaurant_rounded;
      case 'Pakaian & Alas Kaki':
        return Icons.checkroom_rounded;
      case 'Perumahan & Fasilitas':
        return Icons.home_rounded;
      case 'Perawatan Kesehatan':
        return Icons.local_hospital_rounded;
      case 'Transportasi':
        return Icons.directions_car_rounded;
      case 'Komunikasi & Keuangan':
        return Icons.phone_iphone_rounded;
      case 'Rekreasi & Olahraga':
        return Icons.sports_soccer_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

extension on _InflasiScreenState {
  void _showDetailDialog(
    String title,
    String value,
    IconData icon,
    Color color,
    String description,
    ResponsiveSizing sizing,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(dialogContext).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(sizing.statsCardPadding),
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
                      padding: EdgeInsets.all(sizing.categoryIconContainerPadding),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: sizing.categoryIconSize),
                    ),
                    SizedBox(width: sizing.itemSpacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: sizing.groupTitleSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tahun $selectedYear',
                            style: TextStyle(
                              fontSize: sizing.categorySubLabelFontSize,
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
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: sizing.groupIconSize,
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
                  padding: EdgeInsets.all(sizing.statsCardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Value Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(sizing.statsCardPadding),
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
                                fontSize: sizing.categorySubLabelFontSize,
                                color: _bpsTextSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: sizing.itemSpacing),
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: sizing.statsValueFontSize * 1.5,
                                fontWeight: FontWeight.w800,
                                color: color,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: sizing.horizontalPadding),

                      // Description
                      Container(
                        padding: EdgeInsets.all(sizing.statsCardPadding),
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
                              size: sizing.groupIconSize,
                            ),
                            SizedBox(width: sizing.itemSpacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Penjelasan',
                                    style: TextStyle(
                                      fontSize: sizing.categoryLabelFontSize,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                  SizedBox(height: sizing.itemSpacing - 4),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: sizing.categorySubLabelFontSize,
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

                      SizedBox(height: sizing.horizontalPadding),

                      // Additional Info
                      Container(
                        padding: EdgeInsets.all(sizing.statsCardPadding),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: color.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: color,
                              size: sizing.groupIconSize,
                            ),
                            SizedBox(width: sizing.itemSpacing),
                            Expanded(
                              child: Text(
                                'Data bersumber dari Badan Pusat Statistik (BPS) Kota Semarang',
                                style: TextStyle(
                                  fontSize: sizing.categorySubLabelFontSize,
                                  color: _bpsTextSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
