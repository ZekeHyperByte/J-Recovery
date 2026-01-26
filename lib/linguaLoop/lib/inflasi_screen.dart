import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InflasiScreen extends StatefulWidget {
  const InflasiScreen({super.key});

  @override
  State<InflasiScreen> createState() => _InflasiScreenState();
}

class _InflasiScreenState extends State<InflasiScreen> {
  int selectedYear = 2023;
  int? selectedMonth;
  
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  final List<String> fullMonths = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

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
    if (value > 0.5) return Colors.red;
    if (value > 0.2) return Colors.orange;
    if (value >= 0) return Colors.green;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Data Inflasi Indonesia'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildFilterSection(),
            const SizedBox(height: 20),
            _buildKeyMetrics(),
            const SizedBox(height: 20),
            _buildInflationChart(),
            const SizedBox(height: 20),
            _buildMonthlyInflationChart(),
            const SizedBox(height: 20),
            _buildInflationComponents(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
            child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inflasi ${selectedMonth == null ? 'Tahun $selectedYear' : '$currentMonthLabel $selectedYear'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Data resmi Badan Pusat Statistik (BPS)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${currentInflationValue.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildYearFilter(),
          const SizedBox(height: 16),
          _buildMonthFilter(),
        ],
      ),
    );
  }

  Widget _buildYearFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
            const SizedBox(width: 8),
            Text(
              'Tahun',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableYears.map((year) {
            final isSelected = year == selectedYear;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedYear = year;
                  selectedMonth = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  year.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.grey[600], size: 16),
            const SizedBox(width: 8),
            Text(
              'Bulan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: months.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = selectedMonth == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMonth = isSelected ? null : index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3F51B5) : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF3F51B5).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        months[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics() {
    final yearInflation = yearlyInflation[selectedYear] ?? 0.0;
    final coreInfl = coreInflation[selectedYear] ?? 0.0;
    final ihk = ihkData[selectedYear] ?? 0.0;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: [
        _buildMetricCard(
          'Inflasi Tahunan',
          '${yearInflation.toStringAsFixed(2)}%',
          'YoY $selectedYear',
          Icons.trending_up,
          yearInflation > 3 ? Colors.red : yearInflation > 2 ? Colors.orange : Colors.green,
        ),
        _buildMetricCard(
          selectedMonth == null ? 'Inflasi Bulanan' : 'Inflasi $currentMonthLabel',
          '${currentInflationValue.toStringAsFixed(2)}%',
          selectedMonth == null ? 'MoM Des' : 'MoM ${months[selectedMonth!]}',
          Icons.calendar_month,
          inflationColor,
        ),
        _buildMetricCard(
          'Inflasi Inti',
          '${coreInfl.toStringAsFixed(2)}%',
          'YoY $selectedYear',
          Icons.insights,
          const Color(0xFF3F51B5),
        ),
        _buildMetricCard(
          'Indeks Harga Konsumen',
          ihk.toStringAsFixed(2),
          '2018=100',
          Icons.assessment,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInflationChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Inflasi Tahunan (2019-2023)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 1.0,
                maxY: 4.5,
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ['2019', '2020', '2021', '2022', '2023'];
                        if (value.toInt() < years.length) {
                          return Text(
                            years[value.toInt()],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 2.72),
                      const FlSpot(1, 1.68),
                      const FlSpot(2, 1.87),
                      const FlSpot(3, 4.21),
                      const FlSpot(4, 2.61),
                    ],
                    isCurved: true,
                    color: const Color(0xFF3F51B5),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF3F51B5).withOpacity(0.1),
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

  Widget _buildMonthlyInflationChart() {
    if (filteredMonthlyData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Data tidak tersedia'),
        ),
      );
    }

    final monthlyData = filteredMonthlyData;
    final maxValue = monthlyData.reduce((a, b) => a > b ? a : b) + 0.2;
    final minValue = monthlyData.reduce((a, b) => a < b ? a : b) - 0.2;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedMonth == null
                ? 'Inflasi Bulanan $selectedYear'
                : 'Inflasi $currentMonthLabel $selectedYear',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
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
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
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
                          return Text(
                            months[selectedMonth!],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          if (value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(monthlyData.length, (index) {
                  final value = monthlyData[index];
                  final color = value >= 0 ? Colors.indigo : Colors.red;
                  
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: color,
                        width: selectedMonth != null ? 25 : 10,
                      )
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

  Widget _buildInflationComponents() {
    final yearStr = selectedYear.toString();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Komponen Inflasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...inflationComponents.entries.map((entry) {
            final value = entry.value[yearStr] ?? 0.0;
            final color = _getComponentColor(entry.key);
            
            return _buildComponentItem(
              entry.key,
              '${value.toStringAsFixed(2)}%',
              _getComponentIcon(entry.key),
              color,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildComponentItem(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getComponentColor(String component) {
    switch (component) {
      case 'Makanan, Minuman & Tembakau':
        return Colors.orange;
      case 'Pakaian & Alas Kaki':
        return Colors.purple;
      case 'Perumahan & Fasilitas':
        return Colors.blue;
      case 'Perawatan Kesehatan':
        return Colors.red;
      case 'Transportasi':
        return Colors.green;
      case 'Komunikasi & Keuangan':
        return Colors.indigo;
      case 'Rekreasi & Olahraga':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getComponentIcon(String component) {
    switch (component) {
      case 'Makanan, Minuman & Tembakau':
        return Icons.restaurant;
      case 'Pakaian & Alas Kaki':
        return Icons.checkroom;
      case 'Perumahan & Fasilitas':
        return Icons.home;
      case 'Perawatan Kesehatan':
        return Icons.local_hospital;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Komunikasi & Keuangan':
        return Icons.phone_iphone;
      case 'Rekreasi & Olahraga':
        return Icons.sports_soccer;
      default:
        return Icons.category;
    }
  }
}