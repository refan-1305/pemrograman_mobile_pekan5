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

class ScheduleScreen extends StatefulWidget {
  final AppTab activeTab;
  final ValueChanged<AppTab> onTabChange;
  final User user;

  const ScheduleScreen({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.user,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _isLoading = true;

  // ── Sample data ───────────────────
  final List<ScheduleItem> _schedule = const [
    ScheduleItem(
      hari: 'Senin',
      jam: '08:30 - 10:00',
      matakuliah: 'Algoritma & Struktur Data',
      dosen: 'Dr. Ir. Heru Prasetyo, M.T.',
      status: AttendanceStatus.hadir,
      ruangan: 'Ruang 401',
      deskripsiSingkat: 'Belajar algoritma sorting dan tree structures',
    ),
    ScheduleItem(
      hari: 'Senin',
      jam: '10:15 - 12:45',
      matakuliah: 'Interaksi Manusia & Komputer',
      dosen: 'Fajar Wicaksono, S.Kom., M.I.M.',
      status: AttendanceStatus.online,
      ruangan: 'Lab 201',
      deskripsiSingkat: 'Desain UI/UX dan user experience design',
    ),
    ScheduleItem(
      hari: 'Selasa',
      jam: '13:00 - 15:30',
      matakuliah: 'Sistem Basis Data',
      dosen: 'Irwan Setiawan, M.Kom.',
      status: AttendanceStatus.tidakHadir,
      ruangan: 'Ruang 302',
      deskripsiSingkat: 'Query SQL dan database normalization',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
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
              AppHeader(subtitle: 'Informasi Perkuliahan', user: widget.user),
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
          BottomNavBar(
              activeTab: widget.activeTab, onTabChange: widget.onTabChange),
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
        for (var i = 0; i < 3; i++) ...[
          _SkeletonBox(width: double.infinity, height: 140),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
      children: [
        Text(
          'Jadwal Kuliah ${widget.user.nama.split(' ').first}',
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Lihat semua jadwal perkuliahan Anda minggu ini',
          style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          _schedule.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ScheduleCard(item: _schedule[i], index: i),
          ),
        ),
      ],
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

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
          border:
              Border(left: BorderSide(color: AppColors.brandPrimary, width: 4)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            Text(item.matakuliah,
                style: AppTextStyles.title.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.edit_outlined,
                    size: 14, color: AppColors.brandPrimary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.dosen,
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.brandTextSubtle, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.brandPrimary),
                const SizedBox(width: 6),
                Text(
                  item.ruangan,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.brandTextSubtle, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.deskripsiSingkat,
              style: AppTextStyles.body
                  .copyWith(color: AppColors.brandTextSubtle, fontSize: 12),
            ),
          ],
        ),
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
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _VideoFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.brandPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.video_camera_back_rounded,
          color: Colors.white, size: 24),
    );
  }
}
