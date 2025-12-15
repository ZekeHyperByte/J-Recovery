import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'data_list_screen.dart';
import 'idg_screen.dart';
import 'profile_screen.dart';
import 'map_screen.dart';
// Import screens for statistics categories
import 'tenaga_kerja_screen.dart';
import 'ipm_screen.dart';
import 'kemiskinana_screen.dart';
import 'inflasi_screen.dart';
import 'penduduk_screen.dart';
import 'pertumbuhan_ekonomi_screen.dart';
import 'ipg_screen.dart';
import 'pendidikan_screen.dart';
import 'sdgs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          const DataListScreen(),
          const MapScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Peta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF1976D2),
          flexibleSpace: const FlexibleSpaceBar(
            title: Text(
              'STATISTIK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildStatisticsIconsGrid(),
              const SizedBox(height: 30),
              _buildStatisticsSection(),
              const SizedBox(height: 20),
              _buildRecentPublications(),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsIconsGrid() {
    final List<Map<String, dynamic>> statisticsItems = [
      {
        'icon': Icons.work,
        'title': 'Tenaga Kerja',
        'color': Colors.blue,
        'screen': const TenagaKerjaScreen()
      },
      {
        'icon': Icons.trending_up,
        'title': 'IPM',
        'color': Colors.green,
        'screen': const IpmScreen()
      },
      {
        'icon': Icons.balance,
        'title': 'IPG',
        'color': Colors.purple,
        'screen': const IPGScreen(),
      },
      {
        'icon': Icons.equalizer,
        'title': 'IDG',
        'color': Colors.orange,
        'screen': const IDGScreen(),
      },
      {
        'icon': Icons.domain,
        'title': 'SDGs',
        'color': const Color.fromARGB(255, 58, 183, 58),
        'screen': const SDGSStatisticsPage(),
      },
      {
        'icon': Icons.trending_down,
        'title': 'Kemiskinan',
        'color': Colors.red,
        'screen': const KemiskinanScreen()
      },
      {
        'icon': Icons.attach_money,
        'title': 'Inflasi',
        'color': Colors.indigo,
        'screen': const InflasiScreen()
      },
      {
        'icon': Icons.show_chart,
        'title': 'Pertumbuhan Ekonomi',
        'color': Colors.cyan,
        'screen': const PertumbuhanEkonomiScreen()
      },
      {
        'icon': Icons.school,
        'title': 'Pendidikan',
        'color': Colors.deepPurple,
        'screen': const PendidikanScreen()
      },
      {
        'icon': Icons.people,
        'title': 'Penduduk',
        'color': Colors.brown,
        'screen': const PendudukScreen()
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
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
            'Kategori Statistik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: statisticsItems.length,
            itemBuilder: (context, index) {
              final item = statisticsItems[index];
              return _buildStatisticIcon(
                item['icon'],
                item['title'],
                item['color'],
                item['screen'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticIcon(
      IconData icon, String title, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Terbaru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        _buildPopulationChart(),
        const SizedBox(height: 15),
        const BubbleStatistics(),
      ],
    );
  }

  Widget _buildPopulationChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
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
            'Pertumbuhan Penduduk',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}M',
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ['2018', '2019', '2020', '2021', '2022'];
                        if (value.toInt() < years.length) {
                          return Text(
                            years[value.toInt()],
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 264),
                      const FlSpot(1, 266),
                      const FlSpot(2, 267),
                      const FlSpot(3, 270),
                      const FlSpot(4, 272),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1976D2),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF1976D2).withOpacity(0.1),
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

  Widget _buildRecentPublications() {
    final List<Map<String, dynamic>> staticPublications = [
      {
        'title': 'Statistik Indonesia 2024',
        'category': 'Publikasi Tahunan',
        'date': DateTime(2024, 1, 15),
      },
      {
        'title': 'Indikator Ekonomi Januari 2024',
        'category': 'Berita Resmi Statistik',
        'date': DateTime(2024, 1, 10),
      },
      {
        'title': 'Survei Angkatan Kerja Nasional',
        'category': 'Publikasi',
        'date': DateTime(2024, 1, 5),
      },
      {
        'title': 'Tingkat Kemiskinan Semester II 2023',
        'category': 'Berita Resmi Statistik',
        'date': DateTime(2024, 1, 2),
      },
      {
        'title': 'Inflasi Desember 2023',
        'category': 'Publikasi',
        'date': DateTime(2023, 12, 28),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rilis Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur lihat semua publikasi'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 0),
            itemCount: staticPublications.length,
            itemBuilder: (context, index) {
              final publication = staticPublications[index];
              return _buildPublicationCard(
                publication['title'],
                publication['category'],
                publication['date'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationCard(String title, String category, DateTime date) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
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
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(
                Icons.description,
                size: 40,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
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

// 0====================8 INDIKATOR BUBBLE 8====================D
class BubbleStatistics extends StatefulWidget {
  const BubbleStatistics({super.key});

  @override
  State<BubbleStatistics> createState() => _BubbleStatisticsState();
}

class _BubbleStatisticsState extends State<BubbleStatistics>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BubbleData> bubbles = [];
  double containerWidth = 0;
  double containerHeight = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _updateBubbles();
      });
    });
  }

  void _initializeBubbles() {
    if (bubbles.isEmpty && containerWidth > 0 && containerHeight > 0) {
      double bubbleRadius = 45;
      double margin = 20;
      double effectiveWidth = containerWidth - (margin * 2);
      double effectiveHeight = containerHeight - (margin * 2);
      
      bubbles.addAll([
        BubbleData(
          icon: Icons.people,
          value: '272M',
          label: 'Jumlah Penduduk',
          color: Colors.blue,
          radius: bubbleRadius,
          x: margin + effectiveWidth * 0.15,
          y: margin + effectiveHeight * 0.30,
          minX: margin,
          maxX: containerWidth - margin,
          minY: margin,
          maxY: containerHeight - margin,
        ),
        BubbleData(
          icon: Icons.trending_down,
          value: '9.54%',
          label: 'Tingkat Kemiskinan',
          color: Colors.orange,
          radius: bubbleRadius,
          x: margin + effectiveWidth * 0.70,
          y: margin + effectiveHeight * 0.30,
          minX: margin,
          maxX: containerWidth - margin,
          minY: margin,
          maxY: containerHeight - margin,
        ),
        BubbleData(
          icon: Icons.location_city,
          value: '149/km²',
          label: 'Kepadatan',
          color: Colors.green,
          radius: bubbleRadius,
          x: margin + effectiveWidth * 0.30,
          y: margin + effectiveHeight * 0.70,
          minX: margin,
          maxX: containerWidth - margin,
          minY: margin,
          maxY: containerHeight - margin,
        ),
        BubbleData(
          icon: Icons.trending_up,
          value: '5.31%',
          label: 'Pertumbuhan',
          color: Colors.purple,
          radius: bubbleRadius,
          x: margin + effectiveWidth * 0.80,
          y: margin + effectiveHeight * 0.70,
          minX: margin,
          maxX: containerWidth - margin,
          minY: margin,
          maxY: containerHeight - margin,
        ),
      ]);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateBubbles() {
    if (containerWidth == 0 || containerHeight == 0) return;

    for (var bubble in bubbles) {
      bubble.x += bubble.vx;
      bubble.y += bubble.vy;

      if (bubble.x - bubble.radius < bubble.minX) {
        bubble.x = bubble.minX + bubble.radius;
        bubble.vx = -bubble.vx * 0.7;
      } else if (bubble.x + bubble.radius > bubble.maxX) {
        bubble.x = bubble.maxX - bubble.radius;
        bubble.vx = -bubble.vx * 0.7;
      }

      if (bubble.y - bubble.radius < bubble.minY) {
        bubble.y = bubble.minY + bubble.radius;
        bubble.vy = -bubble.vy * 0.7;
      } else if (bubble.y + bubble.radius > bubble.maxY) {
        bubble.y = bubble.maxY - bubble.radius;
        bubble.vy = -bubble.vy * 0.7;
      }

      bubble.vx += (Random().nextDouble() - 0.5) * 0.05;
      bubble.vy += (Random().nextDouble() - 0.5) * 0.05;

      bubble.vx *= 0.985;
      bubble.vy *= 0.985;

      const minVelocity = 0.15;
      if (bubble.vx.abs() < minVelocity) {
        bubble.vx = (bubble.vx >= 0 ? 1 : -1) * (minVelocity + Random().nextDouble() * 0.1);
      }
      if (bubble.vy.abs() < minVelocity) {
        bubble.vy = (bubble.vy >= 0 ? 1 : -1) * (minVelocity + Random().nextDouble() * 0.1);
      }

      const maxVelocity = 1.2;
      bubble.vx = bubble.vx.clamp(-maxVelocity, maxVelocity);
      bubble.vy = bubble.vy.clamp(-maxVelocity, maxVelocity);
    }

    for (int i = 0; i < bubbles.length; i++) {
      for (int j = i + 1; j < bubbles.length; j++) {
        _checkBubbleCollision(bubbles[i], bubbles[j]);
      }
    }
  }

  void _checkBubbleCollision(BubbleData b1, BubbleData b2) {
    double dx = b2.x - b1.x;
    double dy = b2.y - b1.y;
    double distance = sqrt(dx * dx + dy * dy);
    double minDist = b1.radius + b2.radius;

    if (distance < minDist && distance > 0) {
      double angle = atan2(dy, dx);
      double overlap = minDist - distance;
      double separateX = cos(angle) * overlap * 0.6;
      double separateY = sin(angle) * overlap * 0.6;
      
      b1.x -= separateX;
      b1.y -= separateY;
      b2.x += separateX;
      b2.y += separateY;
      
      double dvx = b2.vx - b1.vx;
      double dvy = b2.vy - b1.vy;
      double dvn = dvx * cos(angle) + dvy * sin(angle);
      
      if (dvn < 0) {
        double restitution = 0.6;
        double impulse = dvn * restitution;
        double impulseX = impulse * cos(angle);
        double impulseY = impulse * sin(angle);
        
        b1.vx += impulseX;
        b1.vy += impulseY;
        b2.vx -= impulseX;
        b2.vy -= impulseY;
        
        double kickStrength = 0.1;
        b1.vx += (Random().nextDouble() - 0.5) * kickStrength;
        b1.vy += (Random().nextDouble() - 0.5) * kickStrength;
        b2.vx += (Random().nextDouble() - 0.5) * kickStrength;
        b2.vy += (Random().nextDouble() - 0.5) * kickStrength;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(15),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          containerWidth = constraints.maxWidth;
          containerHeight = constraints.maxHeight;
          
          if (bubbles.isEmpty) {
            _initializeBubbles();
          }
          
          return Stack(
            children: bubbles.map((bubble) {
              return Positioned(
                left: bubble.x - bubble.radius,
                top: bubble.y - bubble.radius,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      bubble.x += details.delta.dx;
                      bubble.y += details.delta.dy;
                      bubble.vx = details.delta.dx * 0.3;
                      bubble.vy = details.delta.dy * 0.3;
                    });
                  },
                  child: Container(
                    width: bubble.radius * 2,
                    height: bubble.radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          bubble.color.withOpacity(0.25),
                          bubble.color.withOpacity(0.15),
                        ],
                      ),
                      border: Border.all(
                        color: bubble.color.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: bubble.color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          bubble.icon,
                          color: bubble.color,
                          size: 20,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          bubble.value,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            bubble.label,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class BubbleData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final double radius;
  double x;
  double y;
  double vx;
  double vy;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  BubbleData({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.radius,
    double? x,
    double? y,
    this.minX = 0,
    this.maxX = double.infinity,
    this.minY = 0,
    this.maxY = double.infinity,
  })  : x = x ?? 100,
        y = y ?? 100,
        vx = -0.8 + Random().nextDouble() * 1.6,
        vy = -0.8 + Random().nextDouble() * 1.6;
}