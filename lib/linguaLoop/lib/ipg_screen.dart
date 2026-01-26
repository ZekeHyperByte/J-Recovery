import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class IPGData {
  final int year;
  final double? uhh; // Umur Harapan Hidup
  final double? hls; // Harapan Lama Sekolah
  final double? rls; // Rata-rata Lama Sekolah
  final double? ppp; // Pengeluaran per Kapita
  final double? ikg; // Indeks Ketimpangan Gender
  final double? ipg; // Indeks Pembangunan Gender
  final double? uhhMale; // UHH Laki-laki
  final double? uhhFemale; // UHH Perempuan
  final double? hlsMale; // HLS Laki-laki
  final double? hlsFemale; // HLS Perempuan
  final double? rlsMale; // RLS Laki-laki
  final double? rlsFemale; // RLS Perempuan
  final double? pppMale; // PPP Laki-laki
  final double? pppFemale; // PPP Perempuan
  final double? ipmMale; // IPM Laki-laki
  final double? ipmFemale; // IPM Perempuan

  IPGData({
    required this.year,
    this.uhh,
    this.hls,
    this.rls,
    this.ppp,
    this.ikg,
    this.ipg,
    this.uhhMale,
    this.uhhFemale,
    this.hlsMale,
    this.hlsFemale,
    this.rlsMale,
    this.rlsFemale,
    this.pppMale,
    this.pppFemale,
    this.ipmMale,
    this.ipmFemale,
  });

  String get ipgFormatted => ipg != null ? ipg!.toStringAsFixed(1) : 'N/A';
  String get ikgFormatted => ikg != null ? (ikg! * 100).toStringAsFixed(1) : 'N/A';
  String get uhhFormatted => uhh != null ? uhh!.toStringAsFixed(1) : 'N/A';
  String get hlsFormatted => hls != null ? hls!.toStringAsFixed(1) : 'N/A';
  String get rlsFormatted => rls != null ? rls!.toStringAsFixed(1) : 'N/A';
  String get pppFormatted => ppp != null ? (ppp! / 1000).toStringAsFixed(0) : 'N/A';

  // Gender specific formatted values
  String get uhhMaleFormatted => uhhMale != null ? uhhMale!.toStringAsFixed(1) : 'N/A';
  String get uhhFemaleFormatted => uhhFemale != null ? uhhFemale!.toStringAsFixed(1) : 'N/A';
  String get hlsMaleFormatted => hlsMale != null ? hlsMale!.toStringAsFixed(1) : 'N/A';
  String get hlsFemaleFormatted => hlsFemale != null ? hlsFemale!.toStringAsFixed(1) : 'N/A';
  String get rlsMaleFormatted => rlsMale != null ? rlsMale!.toStringAsFixed(1) : 'N/A';
  String get rlsFemaleFormatted => rlsFemale != null ? rlsFemale!.toStringAsFixed(1) : 'N/A';
  String get pppMaleFormatted => pppMale != null ? (pppMale! / 1000).toStringAsFixed(0) : 'N/A';
  String get pppFemaleFormatted => pppFemale != null ? (pppFemale! / 1000).toStringAsFixed(0) : 'N/A';
  
  // Gender percentage calculation for each indicator
  double get uhhGap => (uhhMale != null && uhhFemale != null && uhhMale! > 0) 
      ? ((uhhFemale! - uhhMale!) / uhhMale! * 100) : 0.0;
  double get hlsGap => (hlsMale != null && hlsFemale != null && hlsMale! > 0) 
      ? ((hlsFemale! - hlsMale!) / hlsMale! * 100) : 0.0;
}

class IPGScreen extends StatefulWidget {
  const IPGScreen({super.key});

  @override
  State<IPGScreen> createState() => _IPGScreenState();
}

class _IPGScreenState extends State<IPGScreen> {
  Map<int, IPGData> ipgDataByYear = {};
  List<int> availableYears = [];
  int selectedYear = 2024;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIPGData();
  }

  void _loadIPGData() {
    // Data manual IPG dari tahun 2020-2024
    final List<Map<String, dynamic>> rawData = [
      {
        "Tahun": 2020,
        "UHH_Laki": 71.5,
        "UHH_Perempuan": 75.2,
        "HLS_Laki": 12.8,
        "HLS_Perempuan": 13.1,
        "RLS_Laki": 11.42,
        "RLS_Perempuan": 10.16,
        "PPP_Laki": 16128.0,
        "PPP_Perempuan": 14287.0,
        "IPM_Laki": 85.22,
        "IPM_Perempuan": 81.38,
        "IPG": 95.49,
        "IKG": 0.045,
      },
      {
        "Tahun": 2021,
        "UHH_Laki": 71.6,
        "UHH_Perempuan": 75.3,
        "HLS_Laki": 12.9,
        "HLS_Perempuan": 13.2,
        "RLS_Laki": 11.50,
        "RLS_Perempuan": 10.25,
        "PPP_Laki": 16450.0,
        "PPP_Perempuan": 14520.0,
        "IPM_Laki": 85.65,
        "IPM_Perempuan": 81.82,
        "IPG": 95.67,
        "IKG": 0.044,
      },
      {
        "Tahun": 2022,
        "UHH_Laki": 71.7,
        "UHH_Perempuan": 75.4,
        "HLS_Laki": 13.0,
        "HLS_Perempuan": 13.3,
        "RLS_Laki": 11.58,
        "RLS_Perempuan": 10.34,
        "PPP_Laki": 16780.0,
        "PPP_Perempuan": 14760.0,
        "IPM_Laki": 86.08,
        "IPM_Perempuan": 82.26,
        "IPG": 95.93,
        "IKG": 0.043,
      },
      {
        "Tahun": 2023,
        "UHH_Laki": 71.8,
        "UHH_Perempuan": 75.5,
        "HLS_Laki": 13.1,
        "HLS_Perempuan": 13.4,
        "RLS_Laki": 11.66,
        "RLS_Perempuan": 10.43,
        "PPP_Laki": 17120.0,
        "PPP_Perempuan": 15010.0,
        "IPM_Laki": 86.51,
        "IPM_Perempuan": 82.70,
        "IPG": 95.96,
        "IKG": 0.042,
      },
      {
        "Tahun": 2024,
        "UHH_Laki": 71.9,
        "UHH_Perempuan": 75.6,
        "HLS_Laki": 13.2,
        "HLS_Perempuan": 13.5,
        "RLS_Laki": 11.74,
        "RLS_Perempuan": 10.52,
        "PPP_Laki": 17470.0,
        "PPP_Perempuan": 15270.0,
        "IPM_Laki": 86.94,
        "IPM_Perempuan": 83.14,
        "IPG": 95.37,
        "IKG": 0.041,
      },
    ];

    Map<int, IPGData> processedData = {};

    for (var row in rawData) {
      final int year = row["Tahun"] as int;

      processedData[year] = IPGData(
        year: year,

        // rata-rata
        uhh: ((row["UHH_Laki"] + row["UHH_Perempuan"]) / 2).toDouble(),
        hls: ((row["HLS_Laki"] + row["HLS_Perempuan"]) / 2).toDouble(),
        rls: ((row["RLS_Laki"] + row["RLS_Perempuan"]) / 2).toDouble(),
        ppp: ((row["PPP_Laki"] + row["PPP_Perempuan"]) / 2).toDouble(),

        // indeks
        ipg: (row["IPG"] as num).toDouble(),
        ikg: (row["IKG"] as num).toDouble(),

        // nilai per gender
        uhhMale: (row["UHH_Laki"] as num).toDouble(),
        uhhFemale: (row["UHH_Perempuan"] as num).toDouble(),
        hlsMale: (row["HLS_Laki"] as num).toDouble(),
        hlsFemale: (row["HLS_Perempuan"] as num).toDouble(),
        rlsMale: (row["RLS_Laki"] as num).toDouble(),
        rlsFemale: (row["RLS_Perempuan"] as num).toDouble(),
        pppMale: (row["PPP_Laki"] as num).toDouble(),
        pppFemale: (row["PPP_Perempuan"] as num).toDouble(),

        // tambahan: IPM
        ipmMale: (row["IPM_Laki"] as num).toDouble(),
        ipmFemale: (row["IPM_Perempuan"] as num).toDouble(),
      );
    }

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          ipgDataByYear = processedData;
          availableYears = processedData.keys.toList()..sort();
          if (availableYears.isNotEmpty) {
            selectedYear = availableYears.last;
          }
          isLoading = false;
        });
      }
    });
  }

  IPGData get currentIPGData {
    if (ipgDataByYear.isEmpty) {
      return IPGData(year: selectedYear);
    }
    return ipgDataByYear[selectedYear] ?? ipgDataByYear[availableYears.last]!;
  }

  Future<void> _downloadPDFFromGoogleSheets() async {
    const String pdfUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSH3FNCskAXqg0lRfl44sS7omSzIkAX-csRfyud4PBlN0Wv-aTFAKjLXAlPiJg0ng/pub?output=pdf';
    
    try {
      final Uri url = Uri.parse(pdfUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak dapat membuka link download PDF'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengakses PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Indeks Pembangunan Gender'),
          backgroundColor: const Color(0xFF7B1FA2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF7B1FA2)),
              SizedBox(height: 16),
              Text('Memuat data IPG...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Indeks Pembangunan Gender'),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: const Color.fromARGB(255, 235, 216, 235),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data yang ditampilkan bersumber dari data statistik resmi.'),
                ),
              );
            },
            tooltip: 'Sumber Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildYearSelector(),
            const SizedBox(height: 20),
            _buildIPGStats(),
            const SizedBox(height: 20),
            _buildGenderComparison(),
            const SizedBox(height: 20),
            _buildIPGChart(),
            const SizedBox(height: 20),
            _buildIPGDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final data = currentIPGData;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.balance, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Indeks Pembangunan Gender',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Data IPG tahun ${data.year}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
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
          // ... (kode judul tidak berubah)
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
              // PENYESUAIAN: Coba kecilkan nilai width di sini
              // Ubah angka 68 ini sesuai selera Anda (misal: 65, 70, dst)
              width: 63,
              child: GestureDetector(
                onTap: () => setState(() {
                  selectedYear = year;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color.fromARGB(255, 123, 31, 162) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color.fromARGB(255, 123, 31, 162) : Colors.grey[300]!,
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

  Widget _buildIPGStats() {
    final data = currentIPGData;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'IPG (Indeks)',
            data.ipgFormatted,
            'Pembangunan Gender',
            Icons.balance,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'IKG (Indeks)',
            '${data.ikgFormatted}%',
            'Ketimpangan Gender',
            Icons.equalizer,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderComparison() {
    final data = currentIPGData;
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
            'Perbandingan Gender Tahun ${data.year}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.male, color: Colors.blue[600], size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'Laki-laki',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const Divider(height: 16),
                      _buildComparisonRow('UHH:', '${data.uhhMaleFormatted} thn'),
                      _buildComparisonRow('HLS:', '${data.hlsMaleFormatted} thn'),
                      _buildComparisonRow('RLS:', '${data.rlsMaleFormatted} thn'),
                      _buildComparisonRow('Pendapatan:', '${data.pppMaleFormatted} rb'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.pink[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.female, color: Colors.pink[600], size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'Perempuan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800],
                        ),
                      ),
                      const Divider(height: 16),
                      _buildComparisonRow('UHH:', '${data.uhhFemaleFormatted} thn'),
                      _buildComparisonRow('HLS:', '${data.hlsFemaleFormatted} thn'),
                      _buildComparisonRow('RLS:', '${data.rlsFemaleFormatted} thn'),
                      _buildComparisonRow('Pendapatan:', '${data.pppFemaleFormatted} rb'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add explanation about dual scale
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Text(
              'Catatan: IPG (skala ~95-96) dan IKG (skala ~4-5%) ditampilkan dalam grafik yang sama dengan skala 0-100',
              style: TextStyle(
                fontSize: 10,
                color: Colors.amber[800],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIPGChart() {
    // Prepare data for all years
    List<FlSpot> ipgSpots = [];
    List<FlSpot> ikgSpots = [];

    for (int i = 0; i < availableYears.length; i++) {
      final year = availableYears[i];
      final yearData = ipgDataByYear[year];
      if (yearData != null && yearData.ipg != null && yearData.ikg != null) {
        ipgSpots.add(FlSpot(i.toDouble(), yearData.ipg!));
        ikgSpots.add(FlSpot(i.toDouble(), yearData.ikg! * 100)); // Scale IKG to percentage
      }
    }

    bool hasValidData = ipgSpots.isNotEmpty && ikgSpots.isNotEmpty;

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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tren IPG & IKG (2020-2024)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (hasValidData) ...[
            Row(
              children: [
                Container(
                  width: 14,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'IPG (skala kiri)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 14,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'IKG % (skala kanan)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            height: 300,
            child: hasValidData
                ? LineChart(
                    LineChartData(
                      minY: 94,
                      maxY: 97,
                      minX: 0,
                      maxX: (availableYears.length - 1).toDouble(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 0.5,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.12),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.08),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'IPG',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                              ),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            interval: 0.5,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  value.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'IKG %',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            interval: 0.5,
                            getTitlesWidget: (value, meta) {
                              // Map IPG scale (94-97) to IKG scale (3-6%)
                              double ikgValue = 3.0 + ((value - 94.0) / 3.0) * 3.0;
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  ikgValue.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange[700],
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
                            reservedSize: 32,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < availableYears.length) {
                                bool isSelected = availableYears[index] == selectedYear;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    availableYears[index].toString(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected ? const Color(0xFF7B1FA2) : Colors.grey[600],
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.purple.withOpacity(0.3), width: 1.5),
                          right: BorderSide(color: Colors.orange.withOpacity(0.3), width: 1.5),
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                        ),
                      ),
                      lineBarsData: [
                        // IPG Line
                        LineChartBarData(
                          spots: ipgSpots,
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                          ),
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              bool isSelected = availableYears[index] == selectedYear;
                              return FlDotCirclePainter(
                                radius: isSelected ? 6 : 4,
                                color: Colors.white,
                                strokeWidth: isSelected ? 3 : 2,
                                strokeColor: const Color(0xFF7B1FA2),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7B1FA2).withOpacity(0.15),
                                const Color(0xFF9C27B0).withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // IKG Line (scaled to fit IPG range)
                        LineChartBarData(
                          spots: ikgSpots.map((spot) {
                            // Map IKG (3-6%) to IPG scale (94-97)
                            double ikgPercent = spot.y; // This is already scaled to 3-6 range
                            double scaledY = 94.0 + ((ikgPercent - 3.0) / 3.0) * 3.0;
                            return FlSpot(spot.x, scaledY);
                          }).toList(),
                          isCurved: true,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                          ),
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              bool isSelected = availableYears[index] == selectedYear;
                              return FlDotCirclePainter(
                                radius: isSelected ? 6 : 4,
                                color: Colors.white,
                                strokeWidth: isSelected ? 3 : 2,
                                strokeColor: const Color(0xFFFF9800),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF9800).withOpacity(0.15),
                                const Color(0xFFFFB74D).withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Colors.grey[850]!,
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final int index = barSpot.x.toInt();
                              if (index < 0 || index >= availableYears.length) return null;

                              final year = availableYears[index];
                              final yearData = ipgDataByYear[year];

                              if (barSpot.barIndex == 0) {
                                // IPG
                                return LineTooltipItem(
                                  '${year}\nIPG: ${yearData?.ipgFormatted ?? 'N/A'}',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                );
                              } else {
                                // IKG
                                return LineTooltipItem(
                                  '${year}\nIKG: ${yearData?.ikgFormatted ?? 'N/A'}%',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                );
                              }
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Data tren tidak tersedia',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          // Insight summary
          if (hasValidData && ipgDataByYear.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.05),
                    Colors.orange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights, size: 16, color: Colors.purple[700]),
                      const SizedBox(width: 6),
                      Text(
                        'Analisis Tren 5 Tahun',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTrendInsight(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrendInsight() {
    if (availableYears.length < 2) {
      return Text(
        'Belum cukup data untuk analisis tren',
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      );
    }

    final firstYear = availableYears.first;
    final lastYear = availableYears.last;
    final firstData = ipgDataByYear[firstYear];
    final lastData = ipgDataByYear[lastYear];

    if (firstData == null || lastData == null) {
      return Text(
        'Data tidak lengkap',
        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      );
    }

    final ipgChange = (lastData.ipg ?? 0) - (firstData.ipg ?? 0);
    final ikgChange = ((lastData.ikg ?? 0) - (firstData.ikg ?? 0)) * 100;

    String ipgTrend = ipgChange > 0 ? '↑ naik' : ipgChange < 0 ? '↓ turun' : '→ stabil';
    String ikgTrend = ikgChange > 0 ? '↑ naik' : ikgChange < 0 ? '↓ turun' : '→ stabil';

    Color ipgColor = ipgChange > 0 ? Colors.green : ipgChange < 0 ? Colors.red : Colors.grey;
    Color ikgColor = ikgChange < 0 ? Colors.green : ikgChange > 0 ? Colors.red : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  children: [
                    const TextSpan(text: 'IPG ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ipgTrend,
                      style: TextStyle(color: ipgColor, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${ipgChange.toStringAsFixed(2)} poin (${firstYear}-${lastYear})'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  children: [
                    const TextSpan(text: 'IKG ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ikgTrend,
                      style: TextStyle(color: ikgColor, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${ikgChange.toStringAsFixed(2)}% (${firstYear}-${lastYear})'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Grafik menggunakan dua skala berbeda: IPG (kiri) dan IKG % (kanan) untuk memudahkan perbandingan tren.',
            style: TextStyle(
              fontSize: 9,
              color: Colors.blue[800],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIPGDescription() {
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
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.justify,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text: 'Indeks Pembangunan Gender (IPG) ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Perhitungan IPG (Indeks Pembangunan Gender) adalah indikator penting '
                      'yang mengukur kesenjangan pencapaian pembangunan manusia antara '
                      'perempuan dan laki-laki. Semakin tinggi nilai IPG (mendekati 100), '
                      'maka semakin kecil kesenjangan antara perempuan dan laki-laki. '
                      'Berikut adalah tiga dimensi utama IPG beserta indikator-indikatornya: '
                      '\n\n• Dimensi Kesehatan: Diukur melalui Angka Harapan Hidup (UHH) saat lahir '
                      '\n• Dimensi Pendidikan: Diukur melalui Harapan Lama Sekolah (HLS) dan Rata-rata Lama Sekolah (RLS) '
                      '\n• Dimensi Standar Hidup Layak: Diukur melalui Pendapatan per Kapita yang disesuaikan.'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}