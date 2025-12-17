import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class IDGCardPainter extends CustomPainter {
  final double animationValue;
  
  IDGCardPainter({required this.animationValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF6F00),
          Color(0xFFFF8F00),
          Color(0xFFFFA726),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final path = Path();
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );
    path.addRRect(rect);
    
    canvas.drawShadow(path, const Color(0xFFFF6F00).withOpacity(0.4), 15, true);
    canvas.drawPath(path, paint);
    
    final circle1Paint = Paint()
      ..color = Colors.white.withOpacity(0.08 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2), 
      80 * animationValue, 
      circle1Paint
    );
    
    final circle2Paint = Paint()
      ..color = Colors.white.withOpacity(0.06 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8), 
      100 * animationValue, 
      circle2Paint
    );
    
    final circle3Paint = Paint()
      ..color = Colors.white.withOpacity(0.05 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.6), 
      60 * animationValue, 
      circle3Paint
    );
    
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03 * animationValue)
      ..strokeWidth = 1;
    
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 5),
        Offset(size.width, size.height * i / 5),
        gridPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(IDGCardPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class IDGScreen extends StatefulWidget {
  const IDGScreen({super.key});

  @override
  State<IDGScreen> createState() => _IDGScreenState();
}

class _IDGScreenState extends State<IDGScreen> with TickerProviderStateMixin {
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
        // Load from SharedPreferences
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
        // Load default data
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

      Future.delayed(const Duration(milliseconds: 500), () {
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
      setState(() {
        isLoading = false;
      });
    }
  }

  IDGData get currentIDGData {
    if (idgDataByYear.isEmpty) {
      return IDGData(year: selectedYear);
    }
    return idgDataByYear[selectedYear] ?? idgDataByYear[availableYears.last]!;
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
          title: const Text('Indeks Pemberdayaan Gender'),
          backgroundColor: const Color(0xFFFF6F00),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6F00),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Indeks Pemberdayaan Gender'),
        backgroundColor: const Color(0xFFFF6F00),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data yang ditampilkan bersumber dari data statistik resmi.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Sumber Data',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildYearSelector(),
              const SizedBox(height: 20),
              _buildIDGMainCard(),
              const SizedBox(height: 20),
              _buildIDGStats(),
              const SizedBox(height: 20),
              _buildIDGChart(),
              const SizedBox(height: 20),
              _buildIDGDescription(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final data = currentIDGData;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.groups, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Indeks Pemberdayaan Gender',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Data IDG tahun ${data.year}',
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
                  onTap: () => setState(() {
                    selectedYear = year;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[300]!,
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

  Widget _buildIDGMainCard() {
    final data = currentIDGData;
    return TweenAnimationBuilder<double>(
      key: ValueKey(selectedYear),
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Opacity(
            opacity: value,
            child: _AnimatedIDGCard(data: data, fadeValue: value),
          ),
        );
      },
    );
  }

  Widget _buildIDGStats() {
    final data = currentIDGData;
    return Column(
      children: [
        _buildStatCard(
          'Sumbangan Pendapatan Perempuan',
          '${data.sumbanganFormatted}%',
          'Kontribusi Ekonomi Perempuan',
          Icons.attach_money,
          const Color(0xFFFF6F00),
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Perempuan sebagai Tenaga Profesional',
          '${data.tenagaFormatted}%',
          'Profesional dan Teknis',
          Icons.business_center,
          const Color(0xFFFF6F00),
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Keterlibatan Perempuan di Parlemen',
          '${data.parlemenFormatted}%',
          'Partisipasi Politik dan Pengambilan Keputusan',
          Icons.account_balance,
          const Color(0xFFFF6F00),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIDGChart() {
    List<FlSpot> idgSpots = [];
    List<FlSpot> ikgSpots = [];
    List<String> yearLabels = [];

    for (int i = 0; i < availableYears.length; i++) {
      final year = availableYears[i];
      final data = idgDataByYear[year];
      if (data != null) {
        if (data.idg != null) {
          idgSpots.add(FlSpot(i.toDouble(), data.idg!));
        }
        if (data.ikg != null) {
          double scaledIkg = 64 + (data.ikg! * 53.33);
          ikgSpots.add(FlSpot(i.toDouble(), scaledIkg));
        }
        yearLabels.add(year.toString());
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Icon(Icons.show_chart, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Tren IDG VS IKG',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: idgSpots.isNotEmpty || ikgSpots.isNotEmpty
                ? LineChart(
                    LineChartData(
                      minY: 64,
                      maxY: 80,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 0.5,
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
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF4472C4),
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              double ikgValue = (value - 64) / 53.33;
                              return Text(
                                ikgValue.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFFED7D31),
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
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
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
                          right: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: idgSpots,
                          isCurved: true,
                          color: const Color(0xFF4472C4),
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: const Color(0xFF4472C4),
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: ikgSpots,
                          isCurved: true,
                          color: const Color(0xFFED7D31),
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
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
                              if (index >= 0 && index < availableYears.length) {
                                final year = yearLabels[index];
                                final data = idgDataByYear[availableYears[index]];
                                
                                if (barSpot.barIndex == 0 && data?.idg != null) {
                                  return LineTooltipItem(
                                    '$year\nIDG: ${data!.idg!.toStringAsFixed(2)}',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  );
                                } else if (barSpot.barIndex == 1 && data?.ikg != null) {
                                  return LineTooltipItem(
                                    '$year\nIKG: ${data!.ikg!.toStringAsFixed(2)}',
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
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Data tidak tersedia',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4472C4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'IDG',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFED7D31),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'IKG',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIDGDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apa itu IDG?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
              children: const [
                TextSpan(
                  text: 'Indeks Pemberdayaan Gender (IDG) ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'adalah Indeks Komposit yang mengukur partisipasi dan peran aktif perempuan dalam kehidupan ekonomi maupun politik, dengan tiga fokus dimensi utama yaitu:',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                children: const [
                  TextSpan(
                    text: '1. Sumbangan Pendapatan Perempuan ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '(kontribusi pendapatan perempuan terhadap total pendapatan)',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                children: const [
                  TextSpan(
                    text: '2. Perempuan Sebagai Tenaga Profesional ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '(persentase perempuan sebagai tenaga profesional dan teknis)',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                children: const [
                  TextSpan(
                    text: '3. Keterlibatan Perempuan di Parlemen ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '(persentase perempuan di parlemen)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nilai IDG yang meningkat menunjukkan ketimpangan antara laki-laki terhadap perempuan dalam peran dan kekuatan perempuan dalam hal akses sumberdaya ekonomi dan partisipasi pengambilan keputusan. Sedangkan IKG lebih menunjukkan tingkat kesetaraan perempuan terhadap laki-laki dan hal kesenjangan akses dan kapabilitas dalam hal pembangunan dasar manusia.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ============= ANIMATED IDG CARD CLASS =============

class _AnimatedIDGCard extends StatefulWidget {
  final IDGData data;
  final double fadeValue;

  const _AnimatedIDGCard({required this.data, required this.fadeValue});

  @override
  State<_AnimatedIDGCard> createState() => _AnimatedIDGCardState();
}

class _AnimatedIDGCardState extends State<_AnimatedIDGCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Stack(
            children: [
              CustomPaint(
                painter: IDGCardPainter(animationValue: widget.fadeValue),
                child: const SizedBox(
                  width: double.infinity,
                  height: 180,
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4 * widget.fadeValue),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      key: ValueKey(widget.data.idgFormatted),
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, textValue, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - textValue)),
                          child: Transform.scale(
                            scale: 0.7 + (textValue * 0.3),
                            child: Opacity(
                              opacity: textValue,
                              child: Text(
                                widget.data.idgFormatted,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -1.2,
                                  height: 1.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Indeks Pemberdayaan Gender',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Tahun ${widget.data.year}',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}