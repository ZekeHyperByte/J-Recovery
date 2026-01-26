import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  String appVersion = '1.1.0';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAppInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      // Keep default version if package info fails
    }
  }

  void _handleLogoTap() {
    setState(() {
      _tapCount++;
    });

    // Reset counter setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _tapCount = 0;
        });
      }
    });

    // Jika tap 7 kali dalam 3 detik, buka admin login
    if (_tapCount >= 7) {
      _tapCount = 0;
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 40.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildModernAppBar(isTablet),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildInfoCards(isTablet),
                        const SizedBox(height: 24),
                        _buildContactCards(isTablet),
                        const SizedBox(height: 32),
                        _buildFooter(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(bool isTablet) {
    return SliverAppBar(
      expandedHeight: isTablet ? 300.0 : 260.0,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1976D2),
                Color(0xFF1565C0),
                Color(0xFF0D47A1),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated circles background
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Decorative elements
              Positioned(
                top: 100,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              // Content
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Logo simetris dengan shadow dan glassmorphism
                      // Tap 7 kali untuk membuka admin login (tersembunyi)
                      GestureDetector(
                        onTap: _handleLogoTap,
                        child: Container(
                          width: isTablet ? 120 : 100,
                          height: isTablet ? 120 : 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: const Color(0xFF1976D2).withOpacity(0.3),
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: isTablet ? 88 : 68,
                              height: isTablet ? 88 : 68,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Debug: Print error
                                print('Error loading logo: $error');
                                // Fallback - coba load dari network dulu
                                return Image.network(
                                  'https://semarangkota.bps.go.id/images/logo-bps.png',
                                  width: isTablet ? 76 : 56,
                                  height: isTablet ? 76 : 56,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) {
                                    return const Icon(
                                      Icons.account_balance_rounded,
                                      size: 45,
                                      color: Color(0xFF1976D2),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'BPS KOTA SEMARANG',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Badan Pusat Statistik',
                          style: TextStyle(
                            fontSize: isTablet ? 15 : 14,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
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

  Widget _buildInfoCards(bool isTablet) {
    final cards = [
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Bantuan',
        'subtitle': 'Panduan aplikasi',
        'color': const Color(0xFF2196F3),
        'onTap': _showHelpDialog,
      },
      {
        'icon': Icons.info_outline_rounded,
        'title': 'Tentang',
        'subtitle': 'Versi aplikasi',
        'color': const Color(0xFF4CAF50),
        'onTap': _showAboutDialog,
      },
    ];

    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildSimpleCard(
              icon: card['icon'] as IconData,
              title: card['title'] as String,
              subtitle: card['subtitle'] as String,
              color: card['color'] as Color,
              onTap: card['onTap'] as VoidCallback,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSimpleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCards(bool isTablet) {
    final contacts = [
      {
        'icon': Icons.language_rounded,
        'title': 'Website',
        'value': 'semarangkota.bps.go.id',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.email_rounded,
        'title': 'Email',
        'value': 'bps3374@bps.go.id',
        'color': const Color(0xFFFF5722),
      },
      {
        'icon': Icons.phone_rounded,
        'title': 'Telepon',
        'value': '(024) 3546713',
        'color': const Color(0xFF009688),
      },
      {
        'icon': Icons.location_on_rounded,
        'title': 'Alamat',
        'value': 'Jalan Inspeksi Kali Semarang No.1, Sekayu',
        'color': const Color(0xFFE91E63),
      },
    ];

    return Column(
      children: contacts.map((contact) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildContactCard(
            icon: contact['icon'] as IconData,
            title: contact['title'] as String,
            value: contact['value'] as String,
            color: contact['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          try {
            if (title == 'Website') {
              // Buka website
              final url = Uri.parse('https://$value');
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else if (title == 'Email') {
              // Buka email
              final emailUrl = Uri.parse('mailto:$value');
              await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
            } else if (title == 'Telepon') {
              // Buka telepon
              final telUrl = Uri.parse('tel:${value.replaceAll(RegExp(r'[^\d+]'), '')}');
              await launchUrl(telUrl);
            } else if (title == 'Alamat') {
              // Buka Google Maps dengan query alamat
              final address = Uri.encodeComponent('Jalan Inspeksi Kali Semarang No.1, Sekayu, Kec. Semarang Tengah, Kota Semarang, Jawa Tengah 50132');
              final mapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
              await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tidak dapat membuka $title'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A5F),
                      ),
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Versi $appVersion',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© Badan Pusat Statistik Kota Semarang',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_rounded,
                  size: 40,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Versi $appVersion',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aplikasi resmi Badan Pusat Statistik Kota Semarang untuk menyajikan data statistik yang akurat dan terpercaya.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_center_rounded,
                  size: 40,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Panduan Aplikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 20),
              ..._buildHelpSteps(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHelpSteps() {
    final steps = [
      'Pilih kategori statistik di beranda',
      'Jelajahi data dengan grafik interaktif',
      'Gunakan filter untuk data spesifik',
      'Akses informasi terbaru secara real-time',
    ];

    return steps.asMap().entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${entry.key + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}