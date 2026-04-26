// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final AppTab activeTab;
  final ValueChanged<AppTab> onTabChange;
  final VoidCallback onLogout;
  final User user;

  const ProfileScreen({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.onLogout,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editOpen = false;

  int get _totalPertemuan => widget.user.totalPertemuan;
  int get _hadir          => widget.user.hadirCount;
  double get _attendancePct => _hadir / _totalPertemuan;

  _AttendanceTheme get _theme {
    if (_attendancePct >= 0.90) return _AttendanceTheme.good;
    if (_attendancePct >= 0.70) return _AttendanceTheme.ok;
    return _AttendanceTheme.bad;
  }

  final List<ActivityEntry> _activities = const [
    ActivityEntry(type: 'Login',  time: 'Today, 08:32 AM',      description: 'Session authenticated'),
    ActivityEntry(type: 'Update', time: 'Yesterday, 14:20 PM',   description: 'Profile photo seed updated'),
    ActivityEntry(type: 'Course', time: 'Yesterday, 09:00 AM',   description: 'Accessed Algoritma UI'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBg,
      body: Stack(
        children: [
          Column(
            children: [
              AppHeader(subtitle: 'Profil', user: widget.user),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
                  children: [
                    _ProfileHero(user: widget.user),
                    const SizedBox(height: 24),
                    _AttendanceCard(
                      pct: _attendancePct,
                      hadir: _hadir,
                      total: _totalPertemuan,
                      theme: _theme,
                    ),
                    const SizedBox(height: 16),
                    _IdentityAndStatsGrid(user: widget.user),
                    const SizedBox(height: 16),
                    _ActivityCard(activities: _activities),
                    const SizedBox(height: 24),
                    // Edit Profile button
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _editOpen = true),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: const StadiumBorder(),
                        foregroundColor: AppColors.brandPrimary,
                        side: BorderSide(color: AppColors.brandPrimary.withOpacity(0.2)),
                        textStyle: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Sign Out button
                    ElevatedButton.icon(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: const Color(0xFFFEF2F2),
                        foregroundColor: const Color(0xFFDC2626),
                        elevation: 0,
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BottomNavBar(activeTab: widget.activeTab, onTabChange: widget.onTabChange),
          if (_editOpen)
            _EditProfileModal(
              user: widget.user,
              onClose: () => setState(() => _editOpen = false),
              onSave: (_, __) => setState(() => _editOpen = false),
            ),
        ],
      ),
    );
  }
}

// ─── Profile Hero ─────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  final User user;
  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.brandPrimary, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x202D333A),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://api.dicebear.com/7.x/avataaars/svg?seed=${user.nim}'),
                backgroundColor: Colors.grey[100],
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(user.nama, style: AppTextStyles.display.copyWith(fontSize: 26)),
        const SizedBox(height: 4),
        Text(
          'Student of ${user.kelas}'.toUpperCase(),
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

// ─── Attendance Card ──────────────────────────────────────────────────────────

enum _AttendanceTheme { good, ok, bad }

extension _AttendanceThemeX on _AttendanceTheme {
  Color get color => switch (this) {
        _AttendanceTheme.good => AppColors.statusPresent,
        _AttendanceTheme.ok   => const Color(0xFFD97706),
        _AttendanceTheme.bad  => AppColors.statusAbsent,
      };
  Color get bg => switch (this) {
        _AttendanceTheme.good => const Color(0xFFF0FDF4),
        _AttendanceTheme.ok   => const Color(0xFFFFFBEB),
        _AttendanceTheme.bad  => const Color(0xFFFEF2F2),
      };
  String get badge => switch (this) {
        _AttendanceTheme.good => 'Rajin',
        _AttendanceTheme.ok   => 'Stabil',
        _AttendanceTheme.bad  => 'Perlu Peningkatan',
      };
  IconData get icon => switch (this) {
        _AttendanceTheme.good => Icons.local_fire_department_rounded,
        _AttendanceTheme.ok   => Icons.star_rounded,
        _AttendanceTheme.bad  => Icons.error_outline_rounded,
      };
}

class _AttendanceCard extends StatefulWidget {
  final double pct;
  final int hadir;
  final int total;
  final _AttendanceTheme theme;

  const _AttendanceCard({
    required this.pct,
    required this.hadir,
    required this.total,
    required this.theme,
  });

  @override
  State<_AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<_AttendanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.editorialCard(radius: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS KEHADIRAN', style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text('Tingkat Kehadiran', style: AppTextStyles.headline.copyWith(fontSize: 18)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: t.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(t.icon, size: 14, color: t.color),
                    const SizedBox(width: 4),
                    Text(
                      t.badge.toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: t.color,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Ring chart
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => CustomPaint(
                  size: const Size(88, 88),
                  painter: _RingPainter(
                    progress: widget.pct * _anim.value,
                    color: t.color,
                  ),
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: Center(
                      child: Text(
                        '${(widget.pct * 100).round()}%',
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.brandTextMain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle, height: 1.6),
                        children: [
                          const TextSpan(text: 'Anda telah menghadiri '),
                          TextSpan(text: '${widget.hadir}', style: const TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w700)),
                          const TextSpan(text: ' dari '),
                          TextSpan(text: '${widget.total}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.brandTextMain)),
                          const TextSpan(text: ' pertemuan semester ini.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: _anim,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: widget.pct * _anim.value,
                          backgroundColor: Colors.grey[100],
                          valueColor: AlwaysStoppedAnimation(t.color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final trackPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ─── Identity + Stats Grid ────────────────────────────────────────────────────

class _IdentityAndStatsGrid extends StatelessWidget {
  final User user;
  const _IdentityAndStatsGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Identity card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.editorialCard(radius: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('INFORMASI IDENTITAS', style: AppTextStyles.caption),
                const SizedBox(height: 12),
                for (final row in [
                  (Icons.lock_outline_rounded,  'NIM',          user.nim),
                  (Icons.calendar_today_rounded, 'Tahun Masuk', user.tahunMasuk),
                  (Icons.star_rounded,           'IPK Terakhir', user.gpa),
                ]) ...[
                  _IdentityRow(icon: row.$1, label: row.$2, value: row.$3),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stats card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATISTIK AKADEMIK',
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.6)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatTile(label: 'Total SKS', value: '112'),
                    _StatTile(label: 'MK Aktif',  value: '7'),
                    _StatTile(label: 'Hari Ini',  value: '2 MK'),
                    _StatTile(label: 'Tugas',     value: '3'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IdentityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _IdentityRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.grey[400]),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
            Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)),
        ],
      ),
    );
  }
}

// ─── Activity Card ────────────────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  final List<ActivityEntry> activities;
  const _ActivityCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.editorialCard(radius: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Riwayat Aktivitas', style: AppTextStyles.headline.copyWith(fontSize: 18)),
              Icon(Icons.history_rounded, color: Colors.grey[300], size: 22),
            ],
          ),
          const SizedBox(height: 20),
          ...activities.map((a) => _ActivityRow(entry: a)),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityEntry entry;
  const _ActivityRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.type, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800)),
                    Text(entry.time, style: AppTextStyles.caption.copyWith(fontSize: 9, color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  entry.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.brandTextSubtle,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
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

// ─── Edit Profile Modal ───────────────────────────────────────────────────────

class _EditProfileModal extends StatefulWidget {
  final User user;
  final VoidCallback onClose;
  final void Function(String nama, String kelas) onSave;

  const _EditProfileModal({
    required this.user,
    required this.onClose,
    required this.onSave,
  });

  @override
  State<_EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<_EditProfileModal> {
  late final TextEditingController _namaCtrl;
  late final TextEditingController _kelasCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaCtrl  = TextEditingController(text: widget.user.nama);
    _kelasCtrl = TextEditingController(text: widget.user.kelas);
  }

  @override
  void dispose() { _namaCtrl.dispose(); _kelasCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    widget.onSave(_namaCtrl.text, _kelasCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.45),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: GestureDetector(
          onTap: () {},
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit Profile', style: AppTextStyles.headline),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  LuminousTextField(label: 'Full Name', hint: '', controller: _namaCtrl),
                  const SizedBox(height: 16),
                  LuminousTextField(label: 'Class', hint: '', controller: _kelasCtrl),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 6),
                        child: Text('AVATAR SEED', style: AppTextStyles.label),
                      ),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: widget.user.nim,
                          hintStyle: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Avatar is generated automatically from your student ID.',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 9,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
