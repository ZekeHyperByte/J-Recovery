import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sdgs_data_service.dart';
import 'dart:math';

class UserSDGsScreen extends StatefulWidget {
  const UserSDGsScreen({Key? key}) : super(key: key);

  @override
  State<UserSDGsScreen> createState() => _UserSDGsScreenState();
}

class _UserSDGsScreenState extends State<UserSDGsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;

  List<KotaData> kotaDataList = [];
  List<KotaData> filteredList = [];

  int selectedYear = 2024;
  String selectedKota = '';
  String searchQuery = '';
  bool isLoading = true;

  final List<int> availableYears = [2024, 2023, 2022, 2021, 2020, 2019];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await SDGsDataService.getAllKota();
      if (mounted) {
        setState(() {
          kotaDataList = data;
          filteredList = data;

          if (data.isNotEmpty && selectedKota.isEmpty) {
            selectedKota = data.first.nama;
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

  Future<void> _refreshData() async {
    _headerController.reset();
    _cardController.reset();

    await _loadData();

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _filterSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredList = List.from(kotaDataList);
      } else {
        filteredList = kotaDataList
            .where(
                (kota) => kota.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  List<KotaData> get _searchedKotaList {
    if (searchQuery.isEmpty) {
      return kotaDataList;
    }
    return kotaDataList
        .where((kota) =>
            kota.nama.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  KotaData? _getSelectedKotaData() {
    try {
      if (_searchedKotaList.any((kota) => kota.nama == selectedKota)) {
        return _searchedKotaList
            .firstWhere((kota) => kota.nama == selectedKota);
      }
      return kotaDataList.firstWhere((kota) => kota.nama == selectedKota);
    } catch (e) {
      return _searchedKotaList.isNotEmpty ? _searchedKotaList.first : null;
    }
  }

  double _getIndicatorValue(KotaData kota, String indicator) {
    switch (indicator) {
      case 'samitasilayak':
        return kota.samitasilayak[selectedYear] ?? 0;
      case 'tikRemaja':
        return kota.tikRemaja[selectedYear] ?? 0;
      case 'tikDewasa':
        return kota.tikDewasa[selectedYear] ?? 0;
      case 'aktaLahir':
        return kota.aktaLahir[selectedYear] ?? 0;
      case 'apm':
        return kota.apm[selectedYear] ?? 0;
      case 'apk':
        return kota.apk[selectedYear] ?? 0;
      default:
        return 0;
    }
  }

  List<BarChartGroupData> _getBarChartData() {
    final kotaData = _getSelectedKotaData();
    if (kotaData == null) return [];

    final indicators = [
      _getIndicatorValue(kotaData, 'samitasilayak'),
      _getIndicatorValue(kotaData, 'tikRemaja'),
      _getIndicatorValue(kotaData, 'aktaLahir'),
      _getIndicatorValue(kotaData, 'apm'),
      _getIndicatorValue(kotaData, 'apk'),
    ];

    return List.generate(indicators.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: indicators[index],
            color: _getIndicatorColor(index),
            width: 24,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ],
      );
    });
  }

  Color _getIndicatorColor(int index) {
    const colors = [
      Color(0xFF00A8E8),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFF9C27B0),
      Color(0xFFF44336),
    ];
    return colors[index % colors.length];
  }

  String _getIndicatorLabel(int index) {
    const labels = [
      'Sami\ntasilayak',
      'TIK\nRemaja',
      'Akta\nLahir',
      'APM',
      'APK'
    ];
    return labels[index];
  }

  String _getIndicatorDescription(String indicator) {
    switch (indicator) {
      case 'samitasilayak':
        return 'Goal 6: Air Bersih dan Sanitasi Layak\nRumah tangga dengan akses pada layanan fasilitas kesehatan dasar';
      case 'tikRemaja':
        return 'Goal 17: Inklusi Digital\nKeterampilan TIK - Remaja (usia 15-24 tahun)';
      case 'tikDewasa':
        return 'Goal 17: Inklusi Digital\nKeterampilan TIK - Dewasa (usia 15-59 tahun)';
      case 'aktaLahir':
        return 'Goal 16: Perdamaian & Keadilan\nKepemilikan akta lahir untuk penduduk 0-17 tahun';
      case 'apm':
        return 'Goal 4: Pendidikan Berkualitas\nRasio APM SD/sederajat Kuintil terbawah/teratas';
      case 'apk':
        return 'Goal 4: Pendidikan Berkualitas\nRasio APK SMP/sederajat Kuintil terbawah/teratas';
      default:
        return '';
    }
  }

  bool _isYearAvailable(String indicator) {
    final kotaData = _getSelectedKotaData();
    switch (indicator) {
      case 'samitasilayak':
      case 'tikRemaja':
      case 'tikDewasa':
        return kotaData?.samitasilayak.containsKey(selectedYear) ?? false;
      case 'aktaLahir':
      case 'apm':
      case 'apk':
        return kotaData?.aktaLahir.containsKey(selectedYear) ?? false;
      default:
        return false;
    }
  }

  Widget _buildYearItem(int year) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedYear = year);
          _cardController.reset();
          _cardController.forward();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selectedYear == year ? Colors.blue.shade600 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedYear == year
                  ? Colors.blue.shade600
                  : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: selectedYear == year
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Text(
            year.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selectedYear == year ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                    Colors.pink.shade50,
                  ],
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAnimatedHeader(),
                    _buildYearSelector(),
                    _buildSearchBar(),
                    _buildKotaSelector(),
                    _buildIndicatorCards(),
                    _buildChartSection(),
                    _buildComparisonChart(),
                    _buildSDGsInfo(),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        backgroundColor: const Color(0xFF1976D2),
        tooltip: 'Refresh Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _headerAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5),
            end: Offset.zero,
          ).animate(_headerAnimation),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade600,
                  Colors.purple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.public,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SDGs Jawa Tengah',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sustainable Development Goals',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tahun: $selectedYear',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Total: ${kotaDataList.length} kota',
                        style: const TextStyle(
                          fontSize: 14,
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
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _headerAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Tahun Data',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildYearItem(2024),
                        _buildYearItem(2023),
                        _buildYearItem(2022),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildYearItem(2021),
                        _buildYearItem(2020),
                        _buildYearItem(2019),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _headerAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cari Kota/Kabupaten',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ketik nama kota/kabupaten...',
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _filterSearch(''),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  onChanged: _filterSearch,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKotaSelector() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _headerAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kota/Kabupaten',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value:
                      _searchedKotaList.any((kota) => kota.nama == selectedKota)
                          ? selectedKota
                          : (_searchedKotaList.isNotEmpty
                              ? _searchedKotaList.first.nama
                              : null),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _searchedKotaList.map((kota) {
                    return DropdownMenuItem(
                      value: kota.nama,
                      child: Text(
                        kota.nama,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedKota = value);
                      _cardController.reset();
                      _cardController.forward();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorCards() {
    final kotaData = _getSelectedKotaData();

    if (kotaData == null) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Tidak ada data untuk kota yang dipilih',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      );
    }

    final stats = [
      {
        'title': 'samitasilayak',
        'value': _isYearAvailable('samitasilayak')
            ? _getIndicatorValue(kotaData, 'samitasilayak')
            : 0.0,
        'icon': Icons.clean_hands,
        'color': const Color(0xFF00A8E8),
        'description': _getIndicatorDescription('samitasilayak'),
        'available': _isYearAvailable('samitasilayak'),
      },
      {
        'title': 'TIK Remaja',
        'value': _isYearAvailable('tikRemaja')
            ? _getIndicatorValue(kotaData, 'tikRemaja')
            : 0.0,
        'icon': Icons.computer,
        'color': const Color(0xFF4CAF50),
        'description': _getIndicatorDescription('tikRemaja'),
        'available': _isYearAvailable('tikRemaja'),
      },
      {
        'title': 'Akta Lahir',
        'value': _isYearAvailable('aktaLahir')
            ? _getIndicatorValue(kotaData, 'aktaLahir')
            : 0.0,
        'icon': Icons.assignment,
        'color': const Color(0xFFFF9800),
        'description': _getIndicatorDescription('aktaLahir'),
        'available': _isYearAvailable('aktaLahir'),
      },
      {
        'title': 'APM',
        'value':
            _isYearAvailable('apm') ? _getIndicatorValue(kotaData, 'apm') : 0.0,
        'icon': Icons.school,
        'color': const Color(0xFF9C27B0),
        'description': _getIndicatorDescription('apm'),
        'available': _isYearAvailable('apm'),
      },
      {
        'title': 'APK',
        'value':
            _isYearAvailable('apk') ? _getIndicatorValue(kotaData, 'apk') : 0.0,
        'icon': Icons.auto_graph,
        'color': const Color(0xFFF44336),
        'description': _getIndicatorDescription('apk'),
        'available': _isYearAvailable('apk'),
      },
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indikator SDGs - $selectedYear',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              selectedKota,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final stat = stats[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FadeTransition(
                      opacity: _cardAnimation,
                      child: _buildIndicatorCard(
                        title: stat['title'] as String,
                        value: stat['value'] as double,
                        icon: stat['icon'] as IconData,
                        color: stat['color'] as Color,
                        description: stat['description'] as String,
                        available: stat['available'] as bool,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
    required String description,
    required bool available,
  }) {
    final percentage = available ? (value.clamp(0, 100) / 100) : 0.0;

    return Tooltip(
      message: description,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: available ? color.withOpacity(0.25) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation(color),
                    backgroundColor: color.withOpacity(0.15),
                  ),
                ),
                Icon(icon, color: color, size: 28),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              available ? '${value.toStringAsFixed(1)}%' : 'N/A',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: available ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    final kotaData = _getSelectedKotaData();
    final hasData = kotaData != null &&
        (_isYearAvailable('samitasilayak') ||
            _isYearAvailable('tikRemaja') ||
            _isYearAvailable('aktaLahir') ||
            _isYearAvailable('apm') ||
            _isYearAvailable('apk'));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: FadeTransition(
          opacity: _cardAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbandingan Indikator',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Data untuk ${kotaData?.nama ?? 'Kota'} - Tahun $selectedYear',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                if (!hasData)
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              size: 40, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'Data tidak tersedia untuk tahun ini',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 280,
                    child: BarChart(
                      BarChartData(
                        barGroups: _getBarChartData(),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.15),
                              strokeWidth: 0.8,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _getIndicatorLabel(value.toInt()),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        maxY: 110,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    final allKotaNames = kotaDataList.map((k) => k.nama).toList();
    final allTikRemaja =
        kotaDataList.map((k) => k.tikRemaja[selectedYear] ?? 0).toList();

    final sortedData = List.generate(allKotaNames.length, (index) {
      return {
        'nama': allKotaNames[index],
        'value': allTikRemaja[index],
      };
    })
      ..sort((a, b) => (b['value'] as double).compareTo(a['value'] as double));

    final sortedNames = sortedData.map((e) => e['nama'] as String).toList();
    final sortedValues = sortedData.map((e) => e['value'] as double).toList();

    if (sortedValues.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    final average = sortedValues.reduce((a, b) => a + b) / sortedValues.length;
    final highest = sortedValues.first;
    final lowest = sortedValues.last;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: FadeTransition(
          opacity: _cardAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TIK Remaja - Perbandingan Antar Kota',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tahun $selectedYear',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildComparisonStatItem(
                        'Rata-rata',
                        '${average.toStringAsFixed(1)}%',
                        Icons.bar_chart,
                        Colors.blue,
                      ),
                      _buildComparisonStatItem(
                        'Tertinggi',
                        '${highest.toStringAsFixed(1)}%',
                        Icons.arrow_upward,
                        Colors.green,
                      ),
                      _buildComparisonStatItem(
                        'Terendah',
                        '${lowest.toStringAsFixed(1)}%',
                        Icons.arrow_downward,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: max(
                          MediaQuery.of(context).size.width - 40,
                          sortedNames.length * 35.0,
                        ),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            maxY: highest + 10,
                            barGroups:
                                List.generate(sortedNames.length, (index) {
                              final isSelected =
                                  sortedNames[index] == selectedKota;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: sortedValues[index],
                                    color: isSelected
                                        ? Colors.blue.shade600
                                        : Colors.blue.shade300,
                                    width: 18,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.15),
                                  strokeWidth: 0.8,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= sortedNames.length)
                                      return const SizedBox();
                                    final nama = sortedNames[value.toInt()];
                                    final isSelected = nama == selectedKota;
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            nama.length > 14
                                                ? '${nama.substring(0, 12)}..'
                                                : nama,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.blue.shade600
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  reservedSize: 50,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 20,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildComparisonStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSDGsInfo() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _cardAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade900,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Tentang TPB/SDGs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tujuan Pembangunan Berkelanjutan/Sustainable Development Goals (TPB/SDGs) merupakan komitmen global dan nasional dalam upaya untuk menyejahterakan masyarakat mencakup 17 tujuan dan sasaran global tahun 2030 yang dideklarasikan baik oleh negara maju maupun negara berkembang di Sidang Umum PBB pada September 2015.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '17 Tujuan SDGs:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              _buildSDGsGrid(),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Text(
                  'Data dalam aplikasi ini berkontribusi pada Tujuan 4 (Pendidikan), Tujuan 6 (Air Bersih), Tujuan 16 (Keadilan), dan Tujuan 17 (Kemitraan) SDGs',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSDGsGrid() {
    final sdgsList = [
      '1. Tanpa Kemiskinan',
      '2. Tanpa Kelaparan',
      '3. Kehidupan Sehat',
      '4. Pendidikan',
      '5. Kesetaraan Gender',
      '6. Air Bersih',
      '7. Energi Bersih',
      '8. Pekerjaan Layak',
      '9. Industri & Inovasi',
      '10. Berkurang Kesenjangan',
      '11. Kota Berkelanjutan',
      '12. Konsumsi Bertanggung Jawab',
      '13. Perubahan Iklim',
      '14. Ekosistem Lautan',
      '15. Ekosistem Daratan',
      '16. Perdamaian & Keadilan',
      '17. Kemitraan',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 2.2,
      ),
      itemCount: sdgsList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Center(
            child: Text(
              sdgsList[index],
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
