import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SDGSStatisticsPage extends StatefulWidget {
  const SDGSStatisticsPage({Key? key}) : super(key: key);

  @override
  State<SDGSStatisticsPage> createState() => _SDGSStatisticsPageState();
}

class _SDGSStatisticsPageState extends State<SDGSStatisticsPage> {
  String selectedYear = '2024';
  final List<String> years = ['2020', '2021', '2022', '2023', '2024'];

  // Data untuk grafik
  final Map<String, Map<String, dynamic>> yearlyData = {
    '2020': {
      'goal4': 85.2,
      'goal6': 78.5,
      'goal16': 82.1,
      'goal17': 65.3,
    },
    '2021': {
      'goal4': 87.8,
      'goal6': 81.2,
      'goal16': 84.5,
      'goal17': 68.9,
    },
    '2022': {
      'goal4': 89.5,
      'goal6': 83.7,
      'goal16': 86.2,
      'goal17': 72.4,
    },
    '2023': {
      'goal4': 91.3,
      'goal6': 85.9,
      'goal16': 88.7,
      'goal17': 75.8,
    },
    '2024': {
      'goal4': 93.1,
      'goal6': 88.2,
      'goal16': 90.5,
      'goal17': 79.2,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4CAF50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SDGs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Icon
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50),
                    const Color(0xFF66BB6A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistik SDGs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Data Kota Semarang - BPS Sakernas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Year Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, 
                        color: Color(0xFF4CAF50), size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Pilih Tahun Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: years.map((year) {
                        final isSelected = year == selectedYear;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = year;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                year,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
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
            ),

            const SizedBox(height: 24),

            // Chart Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE8F5E9),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.trending_up, 
                          color: Color(0xFF4CAF50), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Capaian SDGs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF37474F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tahun $selectedYear',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: const Color(0xFF37474F),
                              tooltipPadding: const EdgeInsets.all(8),
                              tooltipMargin: 8,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.toStringAsFixed(1)}%',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['Goal 4', 'Goal 6', 'Goal 16', 'Goal 17'];
                                  if (value.toInt() >= 0 && value.toInt() < titles.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        titles[value.toInt()],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF37474F),
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF757575),
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
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: const Color(0xFFE8F5E9),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _buildBarGroup(0, yearlyData[selectedYear]!['goal4']),
                            _buildBarGroup(1, yearlyData[selectedYear]!['goal6']),
                            _buildBarGroup(2, yearlyData[selectedYear]!['goal16']),
                            _buildBarGroup(3, yearlyData[selectedYear]!['goal17']),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SDGs Goal Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag, color: Color(0xFF4CAF50), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Detail Tujuan SDGs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGoalCard(
                    'Goal 4',
                    'Pendidikan Berkualitas',
                    'Rasio APM SD/sederajat dan APK SMP/sederajat Kuintil terbawah/teratas',
                    yearlyData[selectedYear]!['goal4'],
                    Icons.school_rounded,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    'Goal 6',
                    'Air Bersih dan Sanitasi Layak',
                    'Rumah tangga dengan akses pada layanan fasilitas kesehatan dasar dan fasilitas cuci tangan',
                    yearlyData[selectedYear]!['goal6'],
                    Icons.water_drop_rounded,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    'Goal 16',
                    'Perdamaian, Keadilan dan Kelembagaan',
                    'Kepemilikan akta lahir untuk penduduk 0-17 tahun pada 40% berpendapatan bawah',
                    yearlyData[selectedYear]!['goal16'],
                    Icons.balance_rounded,
                    const Color(0xFF9C27B0),
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    'Goal 17',
                    'Inklusi Digital',
                    'Keterampilan teknologi informasi dan komunikasi (TIK)',
                    yearlyData[selectedYear]!['goal17'],
                    Icons.devices_rounded,
                    const Color(0xFFFF9800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFE0B2),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFF9800),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF37474F),
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Catatan: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Jumlah Indikator Tercapai/On-Track/Perlu Perhatian ',
                            ),
                            TextSpan(
                              text: 'masih dalam proses verifikasi dengan Bappeda',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
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

            const SizedBox(height: 20),

            // TPB/SDGs Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.public,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Tentang TPB/SDGs',
                            style: TextStyle(
                              color: Color(0xFF37474F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tujuan Pembangunan Berkelanjutan (TPB)/Sustainable Development Goals (SDGs) merupakan komitmen global dan nasional dalam upaya menyejahterakan masyarakat mencakup 17 tujuan yang dideklarasikan di Sidang Umum PBB September 2015.',
                      style: TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '17 Tujuan: (1) Tanpa Kemiskinan; (2) Tanpa Kelaparan; (3) Kehidupan Sehat dan Sejahtera; (4) Pendidikan Berkualitas; (5) Kesetaraan Gender; (6) Air Bersih dan Sanitasi; (7) Energi Bersih dan Terjangkau; (8) Pekerjaan Layak; (9) Industri dan Inovasi; (10) Berkurangnya Kesenjangan; (11) Kota Berkelanjutan; (12) Konsumsi Bertanggung Jawab; (13) Penanganan Iklim; (14) Ekosistem Lautan; (15) Ekosistem Darat; (16) Perdamaian dan Keadilan; (17) Kemitraan.',
                      style: TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50),
              const Color(0xFF81C784),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 40,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(
    String goalNumber,
    String title,
    String description,
    double percentage,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalNumber,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF37474F),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}