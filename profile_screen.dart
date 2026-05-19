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
  int get _hadir => widget.user.hadirCount;
  double get _attendancePct => _hadir / _totalPertemuan;

  _AttendanceTheme get _theme {
    if (_attendancePct >= 0.90) return _AttendanceTheme.good;
    if (_attendancePct >= 0.70) return _AttendanceTheme.ok;
    return _AttendanceTheme.bad;
  }

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
                    const SizedBox(height: 28),
                    _ProfileInfoCard(user: widget.user),
                    const SizedBox(height: 20),
                    _BioKeahlianCard(user: widget.user),
                    const SizedBox(height: 24),
                    _AttendanceCard(
                      pct: _attendancePct,
                      hadir: _hadir,
                      total: _totalPertemuan,
                      theme: _theme,
                    ),
                    const SizedBox(height: 24),
                    // Edit Profile button
                    FilledButton.icon(
                      onPressed: () => setState(() => _editOpen = true),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Profile'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColors.brandPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Sign Out button
                    OutlinedButton.icon(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sign Out'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        foregroundColor: const Color(0xFFDC2626),
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
          BottomNavBar(
              activeTab: widget.activeTab, onTabChange: widget.onTabChange),
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
        Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.brandPrimary,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandPrimary.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://api.dicebear.com/7.x/avataaars/svg?seed=${user.nim}',
            ),
            backgroundColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user.nama,
          style: AppTextStyles.display.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          user.nim,
          style: AppTextStyles.body.copyWith(
            color: AppColors.brandTextSubtle,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Profile Info Card ────────────────────────────────────────────────────────

class _ProfileInfoCard extends StatelessWidget {
  final User user;
  const _ProfileInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D333A).withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.badge_rounded,
            label: 'Program Studi',
            value: user.prodi,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.class_rounded,
            label: 'Kelas',
            value: user.kelas,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: user.email.isNotEmpty ? user.email : 'Belum ditambahkan',
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Angkatan',
            value: user.angkatan.toString(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.brandPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.brandPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bio Keahlian Card ────────────────────────────────────────────────────────

class _BioKeahlianCard extends StatelessWidget {
  final User user;
  const _BioKeahlianCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final bioText = user.bioKeahlian.isNotEmpty
        ? user.bioKeahlian
        : 'Belum ada informasi keahlian. Klik edit untuk menambahkan.';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: AppColors.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Keahlian & Bio',
                style: AppTextStyles.title.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bioText,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: user.bioKeahlian.isEmpty
                  ? AppColors.brandTextSubtle
                  : AppColors.brandTextMain,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Attendance Card ──────────────────────────────────────────────────────────

enum _AttendanceTheme { good, ok, bad }

extension _AttendanceThemeX on _AttendanceTheme {
  Color get color => switch (this) {
        _AttendanceTheme.good => AppColors.statusPresent,
        _AttendanceTheme.ok => const Color(0xFFD97706),
        _AttendanceTheme.bad => AppColors.statusAbsent,
      };
  Color get bg => switch (this) {
        _AttendanceTheme.good => const Color(0xFFF0FDF4),
        _AttendanceTheme.ok => const Color(0xFFFFFBEB),
        _AttendanceTheme.bad => const Color(0xFFFEF2F2),
      };
  String get badge => switch (this) {
        _AttendanceTheme.good => 'Rajin',
        _AttendanceTheme.ok => 'Stabil',
        _AttendanceTheme.bad => 'Perlu Peningkatan',
      };
  IconData get icon => switch (this) {
        _AttendanceTheme.good => Icons.local_fire_department_rounded,
        _AttendanceTheme.ok => Icons.star_rounded,
        _AttendanceTheme.bad => Icons.error_outline_rounded,
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
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
                  Text('Tingkat Kehadiran',
                      style: AppTextStyles.headline.copyWith(fontSize: 18)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.brandTextSubtle, height: 1.6),
                        children: [
                          const TextSpan(text: 'Anda telah menghadiri '),
                          TextSpan(
                              text: '${widget.hadir}',
                              style: const TextStyle(
                                  color: AppColors.brandPrimary,
                                  fontWeight: FontWeight.w700)),
                          const TextSpan(text: ' dari '),
                          TextSpan(
                              text: '${widget.total}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandTextMain)),
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
    _namaCtrl = TextEditingController(text: widget.user.nama);
    _kelasCtrl = TextEditingController(text: widget.user.kelas);
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _kelasCtrl.dispose();
    super.dispose();
  }

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
                  LuminousTextField(
                      label: 'Full Name', hint: '', controller: _namaCtrl),
                  const SizedBox(height: 16),
                  LuminousTextField(
                      label: 'Class', hint: '', controller: _kelasCtrl),
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
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
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
