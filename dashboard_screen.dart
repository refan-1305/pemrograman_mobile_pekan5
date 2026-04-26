// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class DashboardScreen extends StatefulWidget {
  final AppTab activeTab;
  final ValueChanged<AppTab> onTabChange;
  final User user;

  const DashboardScreen({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  // ── Sample data (mirrors screens.tsx hard-coded arrays) ───────────────────
  final List<ScheduleItem> _schedule = const [
    ScheduleItem(
      hari: 'Senin',
      jam: '08:30 - 10:00',
      matakuliah: 'Algoritma & Struktur Data',
      dosen: 'Dr. Ir. Heru Prasetyo, M.T.',
      status: AttendanceStatus.hadir,
    ),
    ScheduleItem(
      hari: 'Senin',
      jam: '10:15 - 12:45',
      matakuliah: 'Interaksi Manusia & Komputer',
      dosen: 'Fajar Wicaksono, S.Kom., M.I.M.',
      status: AttendanceStatus.online,
    ),
    ScheduleItem(
      hari: 'Selasa',
      jam: '13:00 - 15:30',
      matakuliah: 'Sistem Basis Data',
      dosen: 'Irwan Setiawan, M.Kom.',
      status: AttendanceStatus.tidakHadir,
    ),
  ];

  final List<NewsItem> _news = [
    NewsItem(
      judul: 'Perpustakaan Baru Dibuka',
      deskripsi:
          'Fasilitas modern dengan ribuan koleksi digital terbaru kini dapat diakses mahasiswa.',
      imageUrl:
          'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=800&q=80',
      tag: 'Fasilitas',
    ),
    NewsItem(
      judul: 'Workshop UI/UX Design Bersama Google Indonesia',
      deskripsi:
          'Tingkatkan skill design Anda bersama expert dari industri teknologi ternama.',
      imageUrl:
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&q=80',
      tag: 'Event',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBg,
      body: Stack(
        children: [
          // ── Main scrollable content ──────────────────────────────────────
          Column(
            children: [
              AppHeader(subtitle: 'Dashboard', user: widget.user),
              Expanded(
                child: _isLoading ? _buildSkeleton() : _buildContent(),
              ),
            ],
          ),
          // ── FAB (Video) ──────────────────────────────────────────────────
          Positioned(
            bottom: 96,
            right: 28,
            child: _VideoFAB(),
          ),
          // ── Bottom Nav ───────────────────────────────────────────────────
          BottomNavBar(activeTab: widget.activeTab, onTabChange: widget.onTabChange),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
      children: [
        _SkeletonBox(width: 180, height: 28),
        const SizedBox(height: 8),
        _SkeletonBox(width: 240, height: 16),
        const SizedBox(height: 32),
        for (var i = 0; i < 2; i++) ...[
          _SkeletonBox(width: double.infinity, height: 100),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
      children: [
        // Greeting
        _GreetingSection(greeting: _greeting(), firstName: widget.user.nama.split(' ').first),
        const SizedBox(height: 32),

        // Schedule
        _SectionHeader(title: 'Informasi Kuliah', actionLabel: 'Lihat Kalender', onAction: () {}),
        const SizedBox(height: 16),
        ...List.generate(
          _schedule.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ScheduleCard(item: _schedule[i], index: i),
          ),
        ),
        const SizedBox(height: 20),

        // News
        _SectionHeader(title: 'Berita Kampus', actionLabel: 'Lainnya', onAction: () {}),
        const SizedBox(height: 16),
        ...List.generate(
          _news.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _NewsCard(item: _news[i]),
          ),
        ),
      ],
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  final String greeting;
  final String firstName;

  const _GreetingSection({required this.greeting, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $firstName!',
          style: AppTextStyles.display.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 4),
        Text(
          'Ready to focus on your studies today?',
          style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({required this.title, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.title.copyWith(fontSize: 19)),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.brandPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleItem item;
  final int index;

  const _ScheduleCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 80),
      curve: Curves.easeOut,
      builder: (_, v, child) => Opacity(opacity: v, child: child),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: AppColors.brandPrimary, width: 4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D333A).withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day + time chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${item.hari}, ${item.jam}',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
                StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(item.matakuliah, style: AppTextStyles.title.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.edit_outlined, size: 14, color: AppColors.brandPrimary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.dosen,
                    style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D333A).withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tag.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandPrimary,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(item.judul, style: AppTextStyles.headline.copyWith(fontSize: 19, height: 1.3)),
                const SizedBox(height: 8),
                Text(
                  item.deskripsi,
                  style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle, height: 1.6),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.brandPrimary, AppColors.brandPrimaryDim],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
