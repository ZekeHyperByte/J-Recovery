import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'responsive_sizing.dart';
import 'home_screen.dart';

// BPS Color Palette - Aligned with home_screen.dart
const Color _bpsBlue = Color(0xFF2E99D6);
const Color _bpsOrange = Color(0xFFE88D34);
const Color _bpsGreen = Color(0xFF7DBD42);
const Color _bpsRed = Color(0xFFEF4444);
const Color _bpsBackground = Color(0xFFF5F5F5);
const Color _bpsCardBg = Color(0xFFFFFFFF);
const Color _bpsTextPrimary = Color(0xFF333333);
const Color _bpsTextSecondary = Color(0xFF808080);
const Color _bpsTextLabel = Color(0xFFA0A0A0);
const Color _bpsBorder = Color(0xFFE0E0E0);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String appVersion = '1.1.0';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _tapCount = 0;
  bool _isRefreshing = false;

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
      if (mounted) {
        setState(() {
          appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        });
      }
    } catch (e) {
      // Keep default version if package info fails
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();
    await _loadAppInfo();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _handleLogoTap() {
    setState(() => _tapCount++);

    // Reset counter after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _tapCount = 0);
      }
    });

    // If tap 7 times within 3 seconds, open admin login
    if (_tapCount >= 7) {
      _tapCount = 0;
      Navigator.pushNamed(context, '/login');
    }
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizing = ResponsiveSizing(context);

    return Scaffold(
      backgroundColor: _bpsBackground,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: _bpsBlue,
        backgroundColor: _bpsCardBg,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildAppBar(sizing),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: sizing.horizontalPadding),
              sliver: SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: sizing.sectionSpacing - 8),
                          _buildSectionHeader(
                            sizing: sizing,
                            icon: Icons.apps_rounded,
                            title: 'Menu',
                          ),
                          SizedBox(height: sizing.itemSpacing),
                          _buildInfoCards(sizing),
                          SizedBox(height: sizing.sectionSpacing),
                          _buildSectionHeader(
                            sizing: sizing,
                            icon: Icons.contact_mail_rounded,
                            title: 'Kontak Kami',
                          ),
                          SizedBox(height: sizing.itemSpacing),
                          _buildContactCards(sizing),
                          SizedBox(height: sizing.sectionSpacing + 8),
                          _buildFooter(sizing),
                          SizedBox(height: sizing.sectionSpacing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(sizing),
    );
  }

  Widget _buildAppBar(ResponsiveSizing sizing) {
    return SliverAppBar(
      expandedHeight: sizing.isVerySmall ? 200.0 : 240.0,
      pinned: true,
      stretch: true,
      backgroundColor: _bpsBlue,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: sizing.isVerySmall ? 16 : 24),
                  // Logo with hidden admin access (tap 7 times)
                  GestureDetector(
                    onTap: _handleLogoTap,
                    child: Container(
                      width: sizing.isVerySmall ? 80 : 100,
                      height: sizing.isVerySmall ? 80 : 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(sizing.isVerySmall ? 14 : 16),
                      child: Center(
                        child: Image.asset(
                          'assets/images/jelly.jpg',
                          width: sizing.isVerySmall ? 60 : 72,
                          height: sizing.isVerySmall ? 60 : 72,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://semarangkota.bps.go.id/images/logo-bps.png',
                              width: sizing.isVerySmall ? 52 : 64,
                              height: sizing.isVerySmall ? 52 : 64,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return Icon(
                                  Icons.account_balance_rounded,
                                  size: sizing.isVerySmall ? 40 : 48,
                                  color: _bpsBlue,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sizing.isVerySmall ? 16 : 20),
                  Text(
                    'BPS KOTA SEMARANG',
                    style: TextStyle(
                      fontSize: sizing.isVerySmall ? 16 : 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: sizing.isVerySmall ? 4 : 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizing.isVerySmall ? 12 : 16,
                      vertical: sizing.isVerySmall ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Badan Pusat Statistik',
                      style: TextStyle(
                        fontSize: sizing.isVerySmall ? 12 : 14,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required ResponsiveSizing sizing,
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: _bpsBlue,
          size: sizing.sectionIconSize,
        ),
        SizedBox(width: sizing.itemSpacing - 2),
        Text(
          title,
          style: TextStyle(
            fontSize: sizing.sectionTitleSize,
            fontWeight: FontWeight.w700,
            color: _bpsTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(ResponsiveSizing sizing) {
    final cards = [
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Bantuan',
        'subtitle': 'Panduan aplikasi',
        'color': _bpsBlue,
        'onTap': _showHelpDialog,
      },
      {
        'icon': Icons.info_outline_rounded,
        'title': 'Tentang',
        'subtitle': 'Versi aplikasi',
        'color': _bpsGreen,
        'onTap': _showAboutDialog,
      },
    ];

    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizing.gridSpacing / 2),
            child: _buildActionCard(
              sizing: sizing,
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

  Widget _buildActionCard({
    required ResponsiveSizing sizing,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _bpsCardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(sizing.categoryCardPadding),
          decoration: BoxDecoration(
            color: _bpsCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _bpsBorder,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(sizing.categoryIconContainerPadding + 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: sizing.categoryIconSize + 4,
                ),
              ),
              SizedBox(height: sizing.itemSpacing),
              Text(
                title,
                style: TextStyle(
                  fontSize: sizing.categoryLabelFontSize,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
              SizedBox(height: sizing.itemSpacing - 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: sizing.categorySubLabelFontSize,
                  color: _bpsTextLabel,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCards(ResponsiveSizing sizing) {
    final contacts = [
      {
        'icon': Icons.language_rounded,
        'title': 'Website',
        'value': 'semarangkota.bps.go.id',
        'color': _bpsBlue,
      },
      {
        'icon': Icons.email_rounded,
        'title': 'Email',
        'value': 'bps3374@bps.go.id',
        'color': _bpsOrange,
      },
      {
        'icon': Icons.phone_rounded,
        'title': 'Telepon',
        'value': '(024) 3546713',
        'color': _bpsGreen,
      },
      {
        'icon': Icons.location_on_rounded,
        'title': 'Alamat',
        'value': 'Jl. Inspeksi Kali Semarang No.1, Sekayu',
        'color': _bpsRed,
      },
    ];

    return Column(
      children: contacts.map((contact) {
        return Padding(
          padding: EdgeInsets.only(bottom: sizing.gridSpacing),
          child: _buildContactCard(
            sizing: sizing,
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
    required ResponsiveSizing sizing,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Material(
      color: _bpsCardBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          await _handleContactTap(title, value);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(sizing.categoryCardPadding),
          decoration: BoxDecoration(
            color: _bpsCardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _bpsBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(sizing.categoryIconContainerPadding - 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: sizing.categoryIconSize,
                ),
              ),
              SizedBox(width: sizing.itemSpacing + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: sizing.categorySubLabelFontSize,
                        fontWeight: FontWeight.w500,
                        color: _bpsTextSecondary,
                      ),
                    ),
                    SizedBox(height: sizing.itemSpacing - 6),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: sizing.categoryLabelFontSize - 1,
                        fontWeight: FontWeight.w600,
                        color: _bpsTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _bpsTextLabel,
                size: sizing.categoryArrowSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContactTap(String title, String value) async {
    try {
      if (title == 'Website') {
        final url = Uri.parse('https://$value');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (title == 'Email') {
        final emailUrl = Uri.parse('mailto:$value');
        await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
      } else if (title == 'Telepon') {
        final telUrl = Uri.parse('tel:${value.replaceAll(RegExp(r'[^\d+]'), '')}');
        await launchUrl(telUrl);
      } else if (title == 'Alamat') {
        final address = Uri.encodeComponent(
            'Jalan Inspeksi Kali Semarang No.1, Sekayu, Kec. Semarang Tengah, Kota Semarang, Jawa Tengah 50132');
        final mapsUrl = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$address');
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka $title'),
            backgroundColor: _bpsRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Widget _buildFooter(ResponsiveSizing sizing) {
    return Container(
      padding: EdgeInsets.all(sizing.categoryCardPadding),
      decoration: BoxDecoration(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _bpsBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (_isRefreshing)
            Padding(
              padding: EdgeInsets.only(bottom: sizing.itemSpacing),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_bpsBlue),
                ),
              ),
            ),
          Text(
            'Versi $appVersion',
            style: TextStyle(
              fontSize: sizing.categorySubLabelFontSize,
              color: _bpsTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: sizing.itemSpacing - 4),
          Text(
            '© Badan Pusat Statistik Kota Semarang',
            style: TextStyle(
              fontSize: sizing.categorySubLabelFontSize - 1,
              color: _bpsTextLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ResponsiveSizing sizing) {
    return Container(
      decoration: BoxDecoration(
        color: _bpsCardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: sizing.bottomNavHeight,
          padding: EdgeInsets.symmetric(
            horizontal: sizing.bottomNavPadding,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: false,
                sizing: sizing,
                onTap: _navigateToHome,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: true,
                sizing: sizing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required ResponsiveSizing sizing,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          highlightColor: _bpsBlue.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? _bpsBlue : _bpsTextLabel,
                size: sizing.bottomNavIconSize,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: sizing.bottomNavLabelSize,
                  color: isSelected ? _bpsBlue : _bpsTextLabel,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
                  color: _bpsGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_rounded,
                  size: 40,
                  color: _bpsGreen,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _bpsGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Versi $appVersion',
                  style: TextStyle(
                    fontSize: 13,
                    color: _bpsGreen,
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
                  color: _bpsTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _bpsGreen,
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
                  color: _bpsBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_center_rounded,
                  size: 40,
                  color: _bpsBlue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Panduan Aplikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _bpsTextPrimary,
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
                    backgroundColor: _bpsBlue,
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
                color: _bpsBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${entry.key + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
                    color: _bpsTextSecondary,
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
