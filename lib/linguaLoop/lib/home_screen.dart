import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile_screen.dart';
import 'ipm_screen.dart';
import 'kemiskinana_screen.dart';
import 'inflasi_screen.dart';
import 'penduduk_screen.dart';
import 'pendidikan_screen.dart';
import 'tenaga_kerja_screen.dart';
import 'pertumbuhan_ekonomi_screen.dart';
import 'ipg_screen.dart';
import 'idg_screen.dart';
import 'sdgs_screen.dart';
import 'responsive_sizing.dart';

// BPS Logo Color Palette - Moved outside class for compile-time constants
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

// Category data model - Made immutable for better performance
@immutable
class CategoryItem {
  final String label;
  final String shortLabel;
  final IconData icon;
  final Widget screen;
  final String group;

  const CategoryItem({
    required this.label,
    required this.shortLabel,
    required this.icon,
    required this.screen,
    required this.group,
  });

  CategoryItem copyWith({
    String? label,
    String? shortLabel,
    IconData? icon,
    Widget? screen,
    String? group,
  }) {
    return CategoryItem(
      label: label ?? this.label,
      shortLabel: shortLabel ?? this.shortLabel,
      icon: icon ?? this.icon,
      screen: screen ?? this.screen,
      group: group ?? this.group,
    );
  }
}

// Cache frequently used values
class _HomeScreenCache {
  static final List<CategoryItem> _allCategories = [
    // Economic Indicators Group
    const CategoryItem(
      label: 'Pertumbuhan Ekonomi',
      shortLabel: 'Ekonomi',
      icon: Icons.show_chart_rounded,
      screen: PertumbuhanEkonomiScreen(),
      group: 'Economic',
    ),
    const CategoryItem(
      label: 'Inflasi',
      shortLabel: 'Inflasi',
      icon: Icons.payments_rounded,
      screen: InflasiScreen(),
      group: 'Economic',
    ),
    const CategoryItem(
      label: 'Tenaga Kerja',
      shortLabel: 'Ketenagakerjaan',
      icon: Icons.work_rounded,
      screen: TenagaKerjaScreen(),
      group: 'Economic',
    ),
    const CategoryItem(
      label: 'Kemiskinan',
      shortLabel: 'Kemiskinan',
      icon: Icons.volunteer_activism_rounded,
      screen: KemiskinanScreen(),
      group: 'Economic',
    ),

    // Social Indicators Group
    const CategoryItem(
      label: 'Penduduk',
      shortLabel: 'Penduduk',
      icon: Icons.people_rounded,
      screen: PendudukScreen(),
      group: 'Social',
    ),
    const CategoryItem(
      label: 'Pendidikan',
      shortLabel: 'Pendidikan',
      icon: Icons.school_rounded,
      screen: PendidikanScreen(),
      group: 'Social',
    ),

    // Development Indices Group
    const CategoryItem(
      label: 'Indeks Pembangunan Manusia',
      shortLabel: 'IPM',
      icon: Icons.trending_up_rounded,
      screen: IpmScreen(),
      group: 'Development',
    ),
    const CategoryItem(
      label: 'Indeks Pembangunan Gender',
      shortLabel: 'IPG',
      icon: Icons.balance_rounded,
      screen: IPGScreen(),
      group: 'Development',
    ),
    const CategoryItem(
      label: 'Indeks Ketimpangan Gender',
      shortLabel: 'IDG',
      icon: Icons.bar_chart_rounded,
      screen: IDGScreen(),
      group: 'Development',
    ),
    const CategoryItem(
      label: 'Sustainable Development Goals',
      shortLabel: 'SDGs',
      icon: Icons.public_rounded,
      screen: UserSDGsScreen(),
      group: 'Development',
    ),
  ];

  static List<CategoryItem> get allCategories => _allCategories;

  static final Map<String, Map<String, dynamic>> _groupInfo = {
    'Economic': {'title': 'Indikator Ekonomi', 'icon': Icons.monetization_on_rounded},
    'Social': {'title': 'Indikator Sosial', 'icon': Icons.groups_rounded},
    'Development': {'title': 'Indeks Pembangunan', 'icon': Icons.rocket_launch_rounded},
  };

  static Map<String, Map<String, dynamic>> get groupInfo => _groupInfo;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PageController _statsPageController;
  int _currentStatsPage = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // Debounce for search
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Reduced duration
    )..forward();
    
    _statsPageController = PageController(viewportFraction: 0.9);
    
    // Use a more efficient listener
    _statsPageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    final page = _statsPageController.page?.round() ?? 0;
    if (_currentStatsPage != page) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentStatsPage = page;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _statsPageController.removeListener(_handlePageChange);
    _statsPageController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Optimized search handler with debouncing
  void _handleSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = value;
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    if (mounted) {
      setState(() {
        _searchQuery = '';
      });
    }
  }

  // Optimized filtered categories getter
  List<CategoryItem> get _filteredCategories {
    if (_searchQuery.isEmpty) return _HomeScreenCache.allCategories;
    
    final query = _searchQuery.toLowerCase();
    return _HomeScreenCache.allCategories.where((cat) {
      return cat.label.toLowerCase().contains(query) ||
             cat.shortLabel.toLowerCase().contains(query);
    }).toList();
  }

  // Optimized grouped categories with caching
  Map<String, List<CategoryItem>> get _groupedCategories {
    final result = <String, List<CategoryItem>>{
      'Economic': [],
      'Social': [],
      'Development': [],
    };

    for (final cat in _filteredCategories) {
      result[cat.group]!.add(cat);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Cache the sizing object
    final sizing = ResponsiveSizing(context);
    
    return Scaffold(
      backgroundColor: _bpsBackground,
      body: _HomeScreenContent(
        animationController: _animationController,
        statsPageController: _statsPageController,
        currentStatsPage: _currentStatsPage,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchChanged: _handleSearch,
        onClearSearch: _clearSearch,
        filteredCategories: _filteredCategories,
        groupedCategories: _groupedCategories,
        sizing: sizing,
      ),
      bottomNavigationBar: _buildModernBottomNav(sizing),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  Widget _buildModernBottomNav(ResponsiveSizing sizing) {
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
                isSelected: true,
                sizing: sizing,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: false,
                sizing: sizing,
                onTap: _navigateToProfile,
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
              const SizedBox(height: 4),
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
}

// Extract heavy content to a separate widget to minimize rebuilds
class _HomeScreenContent extends StatelessWidget {
  final AnimationController animationController;
  final PageController statsPageController;
  final int currentStatsPage;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final List<CategoryItem> filteredCategories;
  final Map<String, List<CategoryItem>> groupedCategories;
  final ResponsiveSizing sizing;

  const _HomeScreenContent({
    required this.animationController,
    required this.statsPageController,
    required this.currentStatsPage,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.filteredCategories,
    required this.groupedCategories,
    required this.sizing,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // Header with search
        _buildHeader(),
        
        // Stats snapshot section
        _buildStatsSection(context),
        
        // Categories header
        _buildCategoriesHeader(),
        
        // Category groups
        ..._buildCategoryGroups(context),
        
        // Footer spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: animationController,
        child: Container(
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
              padding: EdgeInsets.fromLTRB(
                sizing.horizontalPadding,
                sizing.horizontalPadding,
                sizing.horizontalPadding,
                sizing.horizontalPadding + 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar with logo
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(sizing.headerLogoPadding),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/logo_white.png',
                          width: sizing.headerLogoSize,
                          height: sizing.headerLogoSize,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                      SizedBox(width: sizing.itemSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BPS KOTA SEMARANG',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: sizing.headerTitleSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Statistik Terpercaya',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: sizing.headerSubtitleSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizing.horizontalPadding),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: _bpsCardBg,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari kategori statistik...',
                        hintStyle: TextStyle(
                          color: _bpsTextLabel,
                          fontSize: sizing.searchFontSize,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: _bpsBlue,
                          size: sizing.searchIconSize,
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: _bpsTextSecondary,
                                  size: sizing.searchClearIconSize,
                                ),
                                onPressed: onClearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sizing.searchPadding,
                          vertical: sizing.searchPadding,
                        ),
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

  SliverToBoxAdapter _buildStatsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutCubic,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                sizing.horizontalPadding,
                sizing.sectionSpacing - 8,
                sizing.horizontalPadding,
                sizing.horizontalPadding - 4,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: _bpsBlue,
                    size: sizing.sectionIconSize,
                  ),
                  SizedBox(width: sizing.itemSpacing - 2),
                  Text(
                    'Snapshot Indikator Utama',
                    style: TextStyle(
                      fontSize: sizing.sectionTitleSize,
                      fontWeight: FontWeight.w700,
                      color: _bpsTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: sizing.statsCardHeight,
              child: PageView(
                controller: statsPageController,
                padEnds: false,
                children: const [
                  _StatsCard1(),
                  _StatsCard2(),
                  _StatsCard3(),
                  _StatsCard4(),
                ],
              ),
            ),
            SizedBox(height: sizing.itemSpacing),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentStatsPage == index
                      ? sizing.pageIndicatorActiveWidth
                      : sizing.pageIndicatorHeight,
                  height: sizing.pageIndicatorHeight,
                  decoration: BoxDecoration(
                    color: currentStatsPage == index
                        ? _bpsBlue
                        : _bpsBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoriesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          sizing.horizontalPadding,
          sizing.sectionSpacing,
          sizing.horizontalPadding,
          sizing.horizontalPadding - 4,
        ),
        child: Row(
          children: [
            Icon(
              Icons.grid_view_rounded,
              color: _bpsBlue,
              size: sizing.sectionIconSize,
            ),
            SizedBox(width: sizing.itemSpacing - 2),
            Text(
              'Jelajahi Statistik',
              style: TextStyle(
                fontSize: sizing.sectionTitleSize,
                fontWeight: FontWeight.w700,
                color: _bpsTextPrimary,
              ),
            ),
            const Spacer(),
            if (searchQuery.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizing.itemSpacing,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _bpsBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${filteredCategories.length} hasil',
                  style: TextStyle(
                    fontSize: sizing.bottomNavLabelSize,
                    fontWeight: FontWeight.w600,
                    color: _bpsBlue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryGroups(BuildContext context) {
    final widgets = <Widget>[];
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 3;

    groupedCategories.forEach((groupKey, categories) {
      if (categories.isEmpty) return;

      final info = _HomeScreenCache.groupInfo[groupKey]!;

      // Group header
      widgets.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              sizing.horizontalPadding,
              sizing.horizontalPadding,
              sizing.horizontalPadding,
              sizing.itemSpacing,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(sizing.groupIconPadding),
                  decoration: BoxDecoration(
                    color: _bpsBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    info['icon'] as IconData,
                    color: _bpsBlue,
                    size: sizing.groupIconSize,
                  ),
                ),
                SizedBox(width: sizing.itemSpacing),
                Text(
                  info['title'] as String,
                  style: TextStyle(
                    fontSize: sizing.groupTitleSize,
                    fontWeight: FontWeight.w700,
                    color: _bpsTextPrimary,
                  ),
                ),
                SizedBox(width: sizing.itemSpacing - 2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizing.itemSpacing - 2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _bpsBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${categories.length}',
                    style: TextStyle(
                      fontSize: sizing.bottomNavLabelSize,
                      fontWeight: FontWeight.w600,
                      color: _bpsBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Category grid
      widgets.add(
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: sizing.horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: sizing.categoryAspectRatio,
              crossAxisSpacing: sizing.gridSpacing,
              mainAxisSpacing: sizing.gridSpacing,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CategoryCard(
                category: categories[index],
                sizing: sizing,
              ),
              childCount: categories.length,
              addAutomaticKeepAlives: true, // Keep cards in memory
            ),
          ),
        ),
      );
    });

    // Empty state
    if (filteredCategories.isEmpty) {
      widgets.add(
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: sizing.horizontalPadding,
              vertical: sizing.sectionSpacing + 8,
            ),
            padding: EdgeInsets.all(sizing.sectionSpacing),
            decoration: BoxDecoration(
              color: _bpsCardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: sizing.isVerySmall ? 48 : 64,
                  color: _bpsTextLabel,
                ),
                SizedBox(height: sizing.horizontalPadding - 4),
                Text(
                  'Tidak ada hasil',
                  style: TextStyle(
                    fontSize: sizing.sectionTitleSize - 2,
                    fontWeight: FontWeight.w600,
                    color: _bpsTextSecondary,
                  ),
                ),
                SizedBox(height: sizing.itemSpacing - 2),
                Text(
                  'Coba kata kunci lain',
                  style: TextStyle(
                    fontSize: sizing.categoryLabelFontSize - 1,
                    color: _bpsTextLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

// Extract individual stat cards to separate widgets for better performance
class _StatsCard1 extends StatelessWidget {
  const _StatsCard1();

  @override
  Widget build(BuildContext context) {
    return _StatsCard(
      label: 'Penduduk',
      value: '1.709M',
      change: '+1.2%',
      isPositive: true,
      accentColor: _bpsBlue,
      icon: Icons.people_rounded,
      chartData: const [1.68, 1.69, 1.69, 1.70, 1.71],
      screen: const PendudukScreen(),
    );
  }
}

class _StatsCard2 extends StatelessWidget {
  const _StatsCard2();

  @override
  Widget build(BuildContext context) {
    return _StatsCard(
      label: 'IPM',
      value: '82.39',
      change: '+2.3%',
      isPositive: true,
      accentColor: _bpsGreen,
      icon: Icons.trending_up_rounded,
      chartData: const [80.5, 81.2, 81.8, 82.1, 82.4],
      screen: const IpmScreen(),
    );
  }
}

class _StatsCard3 extends StatelessWidget {
  const _StatsCard3();

  @override
  Widget build(BuildContext context) {
    return _StatsCard(
      label: 'Kemiskinan',
      value: '4.03%',
      change: '-0.87%',
      isPositive: false,
      accentColor: _bpsOrange,
      icon: Icons.volunteer_activism_rounded,
      chartData: const [4.5, 4.3, 4.2, 4.1, 4.0],
      screen: const KemiskinanScreen(),
    );
  }
}

class _StatsCard4 extends StatelessWidget {
  const _StatsCard4();

  @override
  Widget build(BuildContext context) {
    return _StatsCard(
      label: 'Inflasi',
      value: '2.89%',
      change: '+0.39%',
      isPositive: true,
      accentColor: _bpsRed,
      icon: Icons.payments_rounded,
      chartData: const [2.1, 2.5, 2.8, 2.9, 2.9],
      screen: const InflasiScreen(),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final Color accentColor;
  final IconData icon;
  final List<double> chartData;
  final Widget screen;

  const _StatsCard({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.accentColor,
    required this.icon,
    required this.chartData,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final sizing = ResponsiveSizing(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizing.itemSpacing),
      child: Material(
        color: _bpsCardBg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: _bpsCardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accentColor.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: EdgeInsets.all(sizing.statsCardPadding),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: sizing.statsIconContainerSize,
                  height: sizing.statsIconContainerSize,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: sizing.statsIconSize,
                  ),
                ),
                SizedBox(width: sizing.statsCardPadding - 4),
                // Data column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: sizing.statsLabelFontSize,
                          fontWeight: FontWeight.w600,
                          color: _bpsTextSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: sizing.isVerySmall ? 4 : 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: sizing.statsValueFontSize,
                                fontWeight: FontWeight.w800,
                                color: _bpsTextPrimary,
                                height: 1,
                                letterSpacing: -0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: sizing.isVerySmall ? 4 : 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizing.isVerySmall ? 5 : 8,
                              vertical: sizing.isVerySmall ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? _bpsGreen.withOpacity(0.15)
                                  : _bpsOrange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  color: isPositive ? _bpsGreen : _bpsOrange,
                                  size: sizing.statsChangeIconSize,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  change,
                                  style: TextStyle(
                                    fontSize: sizing.statsChangeFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: isPositive ? _bpsGreen : _bpsOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Mini chart
                SizedBox(
                  width: sizing.statsMiniChartWidth,
                  child: _MiniChart(data: chartData, color: accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  const _MiniChart({
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final spots = List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index]));

    return SizedBox(
      width: 80,
      height: 40,
      child: LineChart(
        LineChartData(
          minY: data.reduce((a, b) => a < b ? a : b) * 0.95,
          maxY: data.reduce((a, b) => a > b ? a : b) * 1.05,
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              color: color,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final ResponsiveSizing sizing;

  const _CategoryCard({
    required this.category,
    required this.sizing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _bpsCardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => category.screen),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
          padding: EdgeInsets.all(sizing.categoryCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(sizing.categoryIconContainerPadding),
                    decoration: BoxDecoration(
                      color: _bpsBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.icon,
                      color: _bpsBlue,
                      size: sizing.categoryIconSize,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _bpsTextLabel,
                    size: sizing.categoryArrowSize,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.shortLabel,
                    style: TextStyle(
                      fontSize: sizing.categoryLabelFontSize,
                      fontWeight: FontWeight.w700,
                      color: _bpsTextPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (category.label != category.shortLabel) ...[
                    SizedBox(height: sizing.isVerySmall ? 2 : 4),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontSize: sizing.categorySubLabelFontSize,
                        color: _bpsTextLabel,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}