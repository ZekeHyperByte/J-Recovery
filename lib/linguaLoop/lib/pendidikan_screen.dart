import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PendidikanScreen extends StatefulWidget {
  const PendidikanScreen({super.key});

  @override
  _PendidikanScreenState createState() => _PendidikanScreenState();
}

class _PendidikanScreenState extends State<PendidikanScreen> {
  String selectedYear = '2022';

  final List<String> years = ['2020', '2021', '2022', '2023', '2024'];

  // Data pendidikan per tahun (Data real Kota Semarang)
  final Map<String, Map<String, dynamic>> educationData = {
    '2020': {
      'angkaMelekHuruf': 96.1,
      'rataRataLamaSekolah': 8.5,
      'harapanLamaSekolah': 12.9,
      'rasioGuruMurid': 16.1,
      'tingkatKelulusan': 98.3,
      'aksesPendidikanTinggi': 31.5,
      'jenjangPendidikan': [
        {'jenjang': 'TK', 'sekolah': 650, 'guru': 2200, 'murid': 28200},
        {'jenjang': 'RA', 'sekolah': 135, 'guru': 680, 'murid': 8600},
        {'jenjang': 'SD', 'sekolah': 490, 'guru': 6950, 'murid': 127800},
        {'jenjang': 'MI', 'sekolah': 88, 'guru': 1150, 'murid': 18700},
        {'jenjang': 'SMP', 'sekolah': 185, 'guru': 3700, 'murid': 62100},
        {'jenjang': 'MTs', 'sekolah': 38, 'guru': 800, 'murid': 9300},
        {'jenjang': 'SMA', 'sekolah': 72, 'guru': 1850, 'murid': 29600},
        {'jenjang': 'SMK', 'sekolah': 83, 'guru': 2400, 'murid': 37200},
        {'jenjang': 'MA', 'sekolah': 30, 'guru': 720, 'murid': 6400},
      ],
      'rasioData': [
        {'jenjang': 'TK/RA', 'rasioSekolahMurid': 43.4, 'rasioGuruMurid': 12.8},
        {
          'jenjang': 'SD/MI',
          'rasioSekolahMurid': 260.8,
          'rasioGuruMurid': 18.4
        },
        {
          'jenjang': 'SMP/MTs',
          'rasioSekolahMurid': 335.7,
          'rasioGuruMurid': 16.8
        },
        {
          'jenjang': 'SMA/SMK/MA',
          'rasioSekolahMurid': 405.5,
          'rasioGuruMurid': 16.3
        },
      ],
      'angkaPutusSekolah': [
        {'tingkat': 'SD', 'persentase': 0.7},
        {'tingkat': 'SMP', 'persentase': 1.2},
        {'tingkat': 'SMA', 'persentase': 2.5},
      ],
      'partisipasiPendidikan': [
        {'jenjang': 'SD/MI/Sederajat', 'apm': 99.60, 'apk': 102.57},
        {'jenjang': 'SMP/MTs/Sederajat', 'apm': 91.77, 'apk': 92.54},
        {'jenjang': 'SMA/SMK/MA/Sederajat', 'apm': 69.95, 'apk': 104.60},
      ],
    },
    '2021': {
      'angkaMelekHuruf': 96.5,
      'rataRataLamaSekolah': 8.7,
      'harapanLamaSekolah': 13.1,
      'rasioGuruMurid': 15.36,
      'tingkatKelulusan': 98.6,
      'aksesPendidikanTinggi': 33.2,
      'jenjangPendidikan': [
        {'jenjang': 'TK', 'sekolah': 668, 'guru': 2272, 'murid': 28986},
        {'jenjang': 'RA', 'sekolah': 137, 'guru': 693, 'murid': 8774},
        {'jenjang': 'SD', 'sekolah': 506, 'guru': 7140, 'murid': 131398},
        {'jenjang': 'MI', 'sekolah': 92, 'guru': 1180, 'murid': 19205},
        {'jenjang': 'SMP', 'sekolah': 191, 'guru': 3802, 'murid': 63809},
        {'jenjang': 'MTs', 'sekolah': 41, 'guru': 823, 'murid': 9538},
        {'jenjang': 'SMA', 'sekolah': 74, 'guru': 1889, 'murid': 30402},
        {'jenjang': 'SMK', 'sekolah': 86, 'guru': 2464, 'murid': 38239},
        {'jenjang': 'MA', 'sekolah': 32, 'guru': 742, 'murid': 6521},
      ],
      'rasioData': [
        {
          'jenjang': 'TK/RA',
          'rasioSekolahMurid': 46.91,
          'rasioGuruMurid': 12.74
        },
        {
          'jenjang': 'SD/MI',
          'rasioSekolahMurid': 251.84,
          'rasioGuruMurid': 18.10
        },
        {
          'jenjang': 'SMP/MTs',
          'rasioSekolahMurid': 316.15,
          'rasioGuruMurid': 15.86
        },
        {
          'jenjang': 'SMA/SMK/MA',
          'rasioSekolahMurid': 391.47,
          'rasioGuruMurid': 14.75
        },
      ],
      'angkaPutusSekolah': [
        {'tingkat': 'SD', 'persentase': 0.6},
        {'tingkat': 'SMP', 'persentase': 1.0},
        {'tingkat': 'SMA', 'persentase': 2.2},
      ],
      'partisipasiPendidikan': [
        {'jenjang': 'SD/MI/Sederajat', 'apm': 99.70, 'apk': 102.80},
        {'jenjang': 'SMP/MTs/Sederajat', 'apm': 92.15, 'apk': 93.20},
        {'jenjang': 'SMA/SMK/MA/Sederajat', 'apm': 71.20, 'apk': 105.30},
      ],
    },
    '2022': {
      'angkaMelekHuruf': 96.9,
      'rataRataLamaSekolah': 8.9,
      'harapanLamaSekolah': 13.3,
      'rasioGuruMurid': 15.36,
      'tingkatKelulusan': 98.9,
      'aksesPendidikanTinggi': 35.1,
      'jenjangPendidikan': [
        {'jenjang': 'TK', 'sekolah': 668, 'guru': 2272, 'murid': 28986},
        {'jenjang': 'RA', 'sekolah': 137, 'guru': 693, 'murid': 8774},
        {'jenjang': 'SD', 'sekolah': 506, 'guru': 7140, 'murid': 131398},
        {'jenjang': 'MI', 'sekolah': 92, 'guru': 1180, 'murid': 19205},
        {'jenjang': 'SMP', 'sekolah': 191, 'guru': 3802, 'murid': 63809},
        {'jenjang': 'MTs', 'sekolah': 41, 'guru': 823, 'murid': 9538},
        {'jenjang': 'SMA', 'sekolah': 74, 'guru': 1889, 'murid': 30402},
        {'jenjang': 'SMK', 'sekolah': 86, 'guru': 2464, 'murid': 38239},
        {'jenjang': 'MA', 'sekolah': 32, 'guru': 742, 'murid': 6521},
      ],
      'rasioData': [
        {
          'jenjang': 'TK/RA',
          'rasioSekolahMurid': 46.91,
          'rasioGuruMurid': 12.74
        },
        {
          'jenjang': 'SD/MI',
          'rasioSekolahMurid': 251.84,
          'rasioGuruMurid': 18.10
        },
        {
          'jenjang': 'SMP/MTs',
          'rasioSekolahMurid': 316.15,
          'rasioGuruMurid': 15.86
        },
        {
          'jenjang': 'SMA/SMK/MA',
          'rasioSekolahMurid': 391.47,
          'rasioGuruMurid': 14.75
        },
      ],
      'angkaPutusSekolah': [
        {'tingkat': 'SD', 'persentase': 0.5},
        {'tingkat': 'SMP', 'persentase': 0.9},
        {'tingkat': 'SMA', 'persentase': 1.9},
      ],
      'partisipasiPendidikan': [
        {'jenjang': 'SD/MI/Sederajat', 'apm': 99.80, 'apk': 103.00},
        {'jenjang': 'SMP/MTs/Sederajat', 'apm': 92.50, 'apk': 93.80},
        {'jenjang': 'SMA/SMK/MA/Sederajat', 'apm': 72.50, 'apk': 106.00},
      ],
    },
    '2023': {
      'angkaMelekHuruf': 97.2,
      'rataRataLamaSekolah': 9.1,
      'harapanLamaSekolah': 13.5,
      'rasioGuruMurid': 15.4,
      'tingkatKelulusan': 99.1,
      'aksesPendidikanTinggi': 37.3,
      'jenjangPendidikan': [
        {'jenjang': 'TK', 'sekolah': 690, 'guru': 2380, 'murid': 29800},
        {'jenjang': 'RA', 'sekolah': 142, 'guru': 710, 'murid': 9000},
        {'jenjang': 'SD', 'sekolah': 512, 'guru': 7320, 'murid': 133200},
        {'jenjang': 'MI', 'sekolah': 95, 'guru': 1200, 'murid': 19800},
        {'jenjang': 'SMP', 'sekolah': 198, 'guru': 3950, 'murid': 65100},
        {'jenjang': 'MTs', 'sekolah': 43, 'guru': 850, 'murid': 9800},
        {'jenjang': 'SMA', 'sekolah': 78, 'guru': 1950, 'murid': 31500},
        {'jenjang': 'SMK', 'sekolah': 90, 'guru': 2550, 'murid': 39500},
        {'jenjang': 'MA', 'sekolah': 35, 'guru': 780, 'murid': 6800},
      ],
      'rasioData': [
        {'jenjang': 'TK/RA', 'rasioSekolahMurid': 43.2, 'rasioGuruMurid': 12.5},
        {
          'jenjang': 'SD/MI',
          'rasioSekolahMurid': 260.2,
          'rasioGuruMurid': 18.2
        },
        {
          'jenjang': 'SMP/MTs',
          'rasioSekolahMurid': 328.8,
          'rasioGuruMurid': 16.5
        },
        {
          'jenjang': 'SMA/SMK/MA',
          'rasioSekolahMurid': 379.1,
          'rasioGuruMurid': 14.9
        },
      ],
      'angkaPutusSekolah': [
        {'tingkat': 'SD', 'persentase': 0.4},
        {'tingkat': 'SMP', 'persentase': 0.8},
        {'tingkat': 'SMA', 'persentase': 1.7},
      ],
      'partisipasiPendidikan': [
        {'jenjang': 'SD/MI/Sederajat', 'apm': 99.85, 'apk': 103.20},
        {'jenjang': 'SMP/MTs/Sederajat', 'apm': 93.00, 'apk': 94.50},
        {'jenjang': 'SMA/SMK/MA/Sederajat', 'apm': 74.00, 'apk': 107.00},
      ],
    },
    '2024': {
      'angkaMelekHuruf': 97.6,
      'rataRataLamaSekolah': 9.3,
      'harapanLamaSekolah': 13.7,
      'rasioGuruMurid': 15.0,
      'tingkatKelulusan': 99.3,
      'aksesPendidikanTinggi': 39.5,
      'jenjangPendidikan': [
        {'jenjang': 'TK', 'sekolah': 705, 'guru': 2450, 'murid': 30200},
        {'jenjang': 'RA', 'sekolah': 145, 'guru': 725, 'murid': 9200},
        {'jenjang': 'SD', 'sekolah': 515, 'guru': 7420, 'murid': 134000},
        {'jenjang': 'MI', 'sekolah': 98, 'guru': 1220, 'murid': 20000},
        {'jenjang': 'SMP', 'sekolah': 202, 'guru': 4020, 'murid': 65800},
        {'jenjang': 'MTs', 'sekolah': 45, 'guru': 870, 'murid': 10000},
        {'jenjang': 'SMA', 'sekolah': 80, 'guru': 2000, 'murid': 32000},
        {'jenjang': 'SMK', 'sekolah': 92, 'guru': 2600, 'murid': 40000},
        {'jenjang': 'MA', 'sekolah': 38, 'guru': 800, 'murid': 7000},
      ],
      'rasioData': [
        {'jenjang': 'TK/RA', 'rasioSekolahMurid': 42.8, 'rasioGuruMurid': 12.3},
        {
          'jenjang': 'SD/MI',
          'rasioSekolahMurid': 260.2,
          'rasioGuruMurid': 18.1
        },
        {
          'jenjang': 'SMP/MTs',
          'rasioSekolahMurid': 325.7,
          'rasioGuruMurid': 16.4
        },
        {
          'jenjang': 'SMA/SMK/MA',
          'rasioSekolahMurid': 375.9,
          'rasioGuruMurid': 14.7
        },
      ],
      'angkaPutusSekolah': [
        {'tingkat': 'SD', 'persentase': 0.3},
        {'tingkat': 'SMP', 'persentase': 0.7},
        {'tingkat': 'SMA', 'persentase': 1.5},
      ],
      'partisipasiPendidikan': [
        {'jenjang': 'SD/MI/Sederajat', 'apm': 99.90, 'apk': 103.50},
        {'jenjang': 'SMP/MTs/Sederajat', 'apm': 93.50, 'apk': 95.20},
        {'jenjang': 'SMA/SMK/MA/Sederajat', 'apm': 75.50, 'apk': 108.00},
      ],
    },
  };

  Map<String, dynamic> get currentData => educationData[selectedYear]!;

  int getTotalMurid(String year) {
    final jenjangData = educationData[year]!['jenjangPendidikan'] as List;
    int total = 0;
    for (var item in jenjangData) {
      total += (item['murid'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 247),
      appBar: AppBar(
        title: const Text('Pendidikan Kota Semarang',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 140, 81, 243),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {})
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildYearSelector(),
          const SizedBox(height: 16),
          _buildMainStatsGrid(),
          const SizedBox(height: 16),
          _buildEducationLevelChart(),
          const SizedBox(height: 16),
          _buildRasioChart(),
          const SizedBox(height: 16),
          _buildPartisipasiChart(),
          const SizedBox(height: 16),
          _buildDropoutRateCard(),
          const SizedBox(height: 16),
          _buildAdditionalStats(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 140, 81, 243),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 125, 76, 209).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kota Semarang',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Data kependidikan tahun $selectedYear',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 251, 253),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 33, 149, 243)
                            .withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: const Icon(Icons.calendar_today,
                    color: Color.fromARGB(255, 135, 200, 235), size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Pilih Tahun Data',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: years.map((year) {
              final isSelected = year == selectedYear;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedYear = year),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: [
                                const Color.fromARGB(255, 196, 30, 229),
                                Colors.blue.shade400
                              ])
                            : null,
                        color: isSelected ? null : Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 33, 173, 243)
                                            .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4))
                              ]
                            : null,
                      ),
                      child: Text(year,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 15)),
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

  Widget _buildMainStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
            'Total Murid',
            '${(getTotalMurid(selectedYear) / 1000).toStringAsFixed(1)}k',
            Icons.groups,
            Colors.blue),
        _buildStatCard('Melek Huruf', '${currentData['angkaMelekHuruf']}%',
            Icons.menu_book, Colors.green),
        _buildStatCard(
            'Rata-rata Lama Sekolah',
            '${currentData['rataRataLamaSekolah']} tahun',
            Icons.timer,
            Colors.orange),
        _buildStatCard(
            'Tingkat Kelulusan',
            '${currentData['tingkatKelulusan']}%',
            Icons.emoji_events,
            Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
              const SizedBox(height: 2),
              Text(title,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationLevelChart() {
    final data = currentData['jenjangPendidikan'] as List;
    final colors = [
      Colors.blue,
      Colors.lightBlue,
      Colors.green,
      Colors.lightGreen,
      Colors.orange,
      Colors.deepOrange,
      Colors.purple,
      Colors.deepPurple,
      Colors.pink
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
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
                  gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple.shade400]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.bar_chart, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Jumlah Murid per Jenjang',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Tahun $selectedYear',
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 140000,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String jenjang = data[groupIndex]['jenjang'] ?? '';
                      String jumlah = (rod.toY / 1000).toStringAsFixed(1);
                      return BarTooltipItem(
                          '$jenjang\n$jumlah ribu murid',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11));
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(data[value.toInt()]['jenjang'] ?? '',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 40000,
                      getTitlesWidget: (value, meta) {
                        return Text('${(value / 1000).toInt()}k',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 40000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200], strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (index) {
                  final muridValue = data[index]['murid'];
                  final muridDouble = (muridValue is int)
                      ? muridValue.toDouble()
                      : (muridValue is double)
                          ? muridValue
                          : 0.0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: muridDouble,
                        gradient: LinearGradient(
                          colors: [
                            colors[index % colors.length],
                            colors[index % colors.length].withOpacity(0.7),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
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

  Widget _buildRasioChart() {
    final rasioData = currentData['rasioData'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
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
                  gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.deepPurple]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.bar_chart, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Rasio Sekolah-Murid dan Guru-Murid',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Kota Semarang - Tahun $selectedYear',
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Colors.pink, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 6),
              const Text('Sekolah-Murid',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 6),
              const Text('Guru-Murid',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 450,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex >= rasioData.length) return null;
                      String jenjang =
                          rasioData[groupIndex]['jenjang']?.toString() ?? '';
                      String label = rodIndex == 0 ? 'Sekolah' : 'Guru';
                      String rasio = rod.toY.toStringAsFixed(2);
                      return BarTooltipItem(
                          '$jenjang\n1 $label : $rasio murid',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10));
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < rasioData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                                rasioData[index]['jenjang']?.toString() ?? '',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 100,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200], strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                barGroups: rasioData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;

                  final rasioSekolahValue = data['rasioSekolahMurid'];
                  double rasioSekolah = 0.0;
                  if (rasioSekolahValue is num) {
                    rasioSekolah = rasioSekolahValue.toDouble();
                  }

                  final rasioGuruValue = data['rasioGuruMurid'];
                  double rasioGuru = 0.0;
                  if (rasioGuruValue is num) {
                    rasioGuru = rasioGuruValue.toDouble();
                  }

                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: rasioSekolah,
                        color: Colors.pink,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: rasioGuru,
                        color: Colors.deepPurple,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartisipasiChart() {
    final partisipasiData = currentData['partisipasiPendidikan'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
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
                  gradient: LinearGradient(
                      colors: [Colors.teal, Colors.green.shade400]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.bar_chart, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Angka Partisipasi Murni (APM) dan Kasar (APK)',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Kota Semarang - Tahun $selectedYear',
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Colors.teal, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 6),
              const Text('APM',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 6),
              const Text('APK',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 110,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex >= partisipasiData.length) return null;
                      String jenjang =
                          partisipasiData[groupIndex]['jenjang']?.toString() ??
                              '';
                      String label = rodIndex == 0 ? 'APM' : 'APK';
                      String nilai = rod.toY.toStringAsFixed(2);
                      return BarTooltipItem(
                          '$jenjang\n$label: $nilai%',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10));
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < partisipasiData.length) {
                          String jenjang =
                              partisipasiData[index]['jenjang']?.toString() ??
                                  '';
                          if (jenjang.length > 15) {
                            jenjang = jenjang.replaceAll('Sederajat', '');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(jenjang,
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                                textAlign: TextAlign.center),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}%',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200], strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                barGroups: partisipasiData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;

                  final apmValue = data['apm'];
                  double apm = 0.0;
                  if (apmValue is num) {
                    apm = apmValue.toDouble();
                  }

                  final apkValue = data['apk'];
                  double apk = 0.0;
                  if (apkValue is num) {
                    apk = apkValue.toDouble();
                  }

                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: apm,
                        color: Colors.teal,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: apk,
                        color: Colors.green.shade400,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropoutRateCard() {
    final dropoutData = currentData['angkaPutusSekolah'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
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
                  gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.orange.shade400]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_down,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Angka Putus Sekolah',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Tahun $selectedYear',
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 16),
          ...dropoutData.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['tingkat'],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      Text('${item['persentase']}%',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: item['persentase'] / 5,
                      minHeight: 7,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAdditionalStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.people, 'Rasio Guru:Murid',
              '1:${currentData['rasioGuruMurid']}', Colors.deepPurple),
          const Divider(height: 20),
          _buildInfoRow(Icons.school, 'Harapan Lama Sekolah',
              '${currentData['harapanLamaSekolah']} tahun', Colors.purple),
          const Divider(height: 20),
          _buildInfoRow(Icons.business, 'Akses Pendidikan Tinggi',
              '${currentData['aksesPendidikanTinggi']}%', Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Text(value,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ],
    );
  }
}