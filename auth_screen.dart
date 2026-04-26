import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/database_helper.dart';

// ─── Auth Router ──────────────────────────────────────────────────────────────

enum _AuthRoute { login, register, forgotPassword, resetPassword }

class AuthScreen extends StatefulWidget {
  final ValueChanged<User> onLogin;

  const AuthScreen({super.key, required this.onLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthRoute _route = _AuthRoute.login;
  String _resetNim = '';
  String _successMsg = '';

  void _navigate(_AuthRoute route) => setState(() {
        _route = route;
        _successMsg = '';
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBg,
      body: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Screen content
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: switch (_route) {
                _AuthRoute.login => LoginView(
                    key: const ValueKey('login'),
                    successMsg: _successMsg,
                    onLogin: widget.onLogin,
                    onNavigate: _navigate,
                  ),
                _AuthRoute.register => RegisterView(
                    key: const ValueKey('register'),
                    onNavigate: _navigate,
                    onSuccess: (msg) => setState(() => _successMsg = msg),
                  ),
                _AuthRoute.forgotPassword => ForgotPasswordView(
                    key: const ValueKey('forgot'),
                    onNavigate: _navigate,
                    onNimFound: (nim) => setState(() => _resetNim = nim),
                  ),
                _AuthRoute.resetPassword => ResetPasswordView(
                    key: const ValueKey('reset'),
                    nim: _resetNim,
                    onNavigate: _navigate,
                    onSuccess: (msg) => setState(() => _successMsg = msg),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Login ────────────────────────────────────────────────────────────────────

class LoginView extends StatefulWidget {
  final String successMsg;
  final ValueChanged<User> onLogin;
  final ValueChanged<_AuthRoute> onNavigate;

  const LoginView({
    super.key,
    required this.successMsg,
    required this.onLogin,
    required this.onNavigate,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nimCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String _error = '';

Future<void> _handleLogin() async {
  setState(() => _error = '');

  final nim = _nimCtrl.text.trim();
  final pw = _pwCtrl.text;

  if (nim.isEmpty || pw.isEmpty) {
    setState(() => _error = 'NIM dan password wajib diisi');
    return;
  }

  setState(() => _isLoading = true);

  try {
    final user = await DatabaseHelper.instance.findUser(nim);

    if (!mounted) return;

    if (user != null && user.password == pw) {
      widget.onLogin(user);
    } else {
      setState(() {
        _error = 'NIM atau password salah';
        _isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      _error = 'Terjadi kesalahan';
      _isLoading = false;
    });
  }
}

  @override
  void dispose() {
    _nimCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          // Logo block
          Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.brandPrimary, AppColors.brandPrimaryDim],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandPrimary.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),
              Text('Luminous',
                  style: AppTextStyles.display.copyWith(fontSize: 36)),
              const SizedBox(height: 6),
              Text(
                'Your sanctuary for focused learning',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.brandTextSubtle),
              ),
            ],
          ),

          const SizedBox(height: 36),

          // Card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: AppDecorations.editorialCard(radius: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.successMsg.isNotEmpty) ...[
                  AlertBanner(message: widget.successMsg, isError: false),
                  const SizedBox(height: 20),
                ],
                if (_error.isNotEmpty) ...[
                  AlertBanner(message: _error),
                  const SizedBox(height: 20),
                ],
                LuminousTextField(
                  label: 'Username (NIM)',
                  hint: 'Masukkan NIM',
                  controller: _nimCtrl,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                LuminousTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _pwCtrl,
                  obscureText: !_showPassword,
                  enabled: !_isLoading,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Login'),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF3F4F6)),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        widget.onNavigate(_AuthRoute.forgotPassword),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.brandTextSubtle,
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => widget.onNavigate(_AuthRoute.register),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontWeight: FontWeight.w900,
                                color: AppColors.brandPrimary,
                                fontSize: 14,
                              ),
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

          const SizedBox(height: 40),
          Text(
            '© 2024 LUMINOUS EDUCATIONAL SYSTEMS',
            style: AppTextStyles.caption.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

// ─── Register ─────────────────────────────────────────────────────────────────

class RegisterView extends StatefulWidget {
  final ValueChanged<_AuthRoute> onNavigate;
  final ValueChanged<String> onSuccess;

  const RegisterView(
      {super.key, required this.onNavigate, required this.onSuccess});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nimCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _kelasCtrl = TextEditingController();
  final _tahunCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _cpwCtrl = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _handleRegister() async {
  setState(() => _error = '');

  final nim = _nimCtrl.text.trim();
  final nama = _namaCtrl.text.trim();
  final kelas = _kelasCtrl.text.trim();
  final tahunText = _tahunCtrl.text.trim();
  final pw = _pwCtrl.text;
  final cpw = _cpwCtrl.text;

  // VALIDASI
  if ([nim, nama, kelas, tahunText, pw, cpw].any((e) => e.isEmpty)) {
    setState(() => _error = 'Semua field wajib diisi');
    return;
  }

  if (int.tryParse(nim) == null) {
    setState(() => _error = 'NIM harus berupa angka');
    return;
  }

  final tahun = int.tryParse(tahunText);
  if (tahun == null || tahun < 2000 || tahun > DateTime.now().year) {
    setState(() => _error = 'Tahun masuk tidak valid');
    return;
  }

  if (pw.length < 6) {
    setState(() => _error = 'Password minimal 6 karakter');
    return;
  }

  if (pw != cpw) {
    setState(() => _error = 'Konfirmasi password tidak sama');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // CEK USER
    final exists = await DatabaseHelper.instance.userExists(nim);

    if (!mounted) return;

    if (exists) {
      setState(() {
        _error = 'NIM sudah terdaftar';
        _isLoading = false;
      });
      return;
    }

    // INSERT USER
    final newUser = User(
      nim: _nimCtrl.text.trim(),
      nama: _namaCtrl.text.trim(),
      kelas: _kelasCtrl.text.trim(),
      prodi: 'Informatika',
      angkatan: int.tryParse(_tahunCtrl.text.trim()) ?? 0,
      foto: '',
      password: _pwCtrl.text,
      gpa: '3.50',
      hadirCount: 12,
      totalPertemuan: 16,
);

    await DatabaseHelper.instance.insertUser(newUser);

    if (!mounted) return;

    setState(() => _isLoading = false);

    widget.onSuccess('Registrasi berhasil! Silakan login.');
    widget.onNavigate(_AuthRoute.login);

  } catch (e) {
    debugPrint('REGISTER ERROR: $e'); // 🔥 penting buat debug

    if (!mounted) return;
    setState(() {
      _error = 'Gagal register: ${e.toString()}';
      _isLoading = false;
    });
  }
}

  @override
  void dispose() {
    for (final c in [
      _nimCtrl,
      _namaCtrl,
      _kelasCtrl,
      _tahunCtrl,
      _pwCtrl,
      _cpwCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => widget.onNavigate(_AuthRoute.login),
            icon: const Icon(Icons.chevron_left_rounded,
                color: AppColors.brandPrimary),
            label: const Text(
              'Kembali ke Login',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                color: AppColors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxHeight: 540),
            decoration: AppDecorations.editorialCard(radius: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Pendaftaran Baru', style: AppTextStyles.headline),
                const SizedBox(height: 4),
                Text('Bergabunglah dengan komunitas Luminous.',
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.brandTextSubtle)),
                const SizedBox(height: 20),
                if (_error.isNotEmpty) ...[
                  AlertBanner(message: _error),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final e in [
                          ('NIM', 'Masukkan NIM', _nimCtrl),
                          ('Nama', 'Masukkan nama lengkap', _namaCtrl),
                          ('Kelas', 'Masukkan kelas', _kelasCtrl),
                          ('Tahun Masuk', 'Masukkan tahun masuk', _tahunCtrl),
                        ]) ...[
                          LuminousTextField(
                              label: e.$1, hint: e.$2, controller: e.$3),
                          const SizedBox(height: 14),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: LuminousTextField(
                                label: 'Password',
                                hint: '••••••',
                                controller: _pwCtrl,
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: LuminousTextField(
                                label: 'Konfirmasi',
                                hint: '••••••',
                                controller: _cpwCtrl,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Buat Akun'),
                        ),
                      ],
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
}

// ─── Forgot Password ──────────────────────────────────────────────────────────

class ForgotPasswordView extends StatefulWidget {
  final ValueChanged<_AuthRoute> onNavigate;
  final ValueChanged<String> onNimFound;

  const ForgotPasswordView(
      {super.key, required this.onNavigate, required this.onNimFound});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _nimCtrl = TextEditingController();
  String _error = '';

  Future<void> _check() async {
    setState(() => _error = '');

    if (_nimCtrl.text.trim().isEmpty) {
      setState(() => _error = 'NIM wajib diisi');
      return;
    }

    try {
      final exists =
          await DatabaseHelper.instance.userExists(_nimCtrl.text.trim());

      if (!mounted) return;

      if (!exists) {
        setState(() => _error = 'NIM tidak ditemukan');
        return;
      }

      widget.onNimFound(_nimCtrl.text.trim());
      widget.onNavigate(_AuthRoute.resetPassword);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Terjadi kesalahan, coba lagi');
    }
  }

  @override
  void dispose() {
    _nimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => widget.onNavigate(_AuthRoute.login),
            icon: const Icon(Icons.chevron_left_rounded,
                color: AppColors.brandPrimary),
            label: const Text(
              'Kembali',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                color: AppColors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: AppDecorations.editorialCard(radius: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Lupa Password?', style: AppTextStyles.headline),
                const SizedBox(height: 8),
                Text(
                  'Masukkan NIM Anda untuk memulihkan akses.',
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.brandTextSubtle),
                ),
                const SizedBox(height: 28),
                LuminousTextField(
                  label: 'NIM Student',
                  hint: 'Contoh: 221001',
                  controller: _nimCtrl,
                  keyboardType: TextInputType.number,
                ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _check,
                  child: const Text('Lanjut'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reset Password ───────────────────────────────────────────────────────────

class ResetPasswordView extends StatefulWidget {
  final String nim;
  final ValueChanged<_AuthRoute> onNavigate;
  final ValueChanged<String> onSuccess;

  const ResetPasswordView({
    super.key,
    required this.nim,
    required this.onNavigate,
    required this.onSuccess,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _pwCtrl = TextEditingController();
  final _cpwCtrl = TextEditingController();
  String _error = '';
  bool _isLoading = false;

  Future<void> _handleReset() async {
    setState(() => _error = '');

    if (_pwCtrl.text.length < 6) {
      setState(() => _error = 'Minimal 6 karakter');
      return;
    }
    if (_pwCtrl.text != _cpwCtrl.text) {
      setState(() => _error = 'Password tidak sama');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DatabaseHelper.instance.updatePassword(widget.nim, _pwCtrl.text);

      if (!mounted) return;

      setState(() => _isLoading = false);

      widget.onSuccess('Password berhasil diperbarui!');
      widget.onNavigate(_AuthRoute.login);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Terjadi kesalahan, coba lagi';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pwCtrl.dispose();
    _cpwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: AppDecorations.editorialCard(radius: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reset Password', style: AppTextStyles.headline),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: AppTextStyles.body
                    .copyWith(color: AppColors.brandTextSubtle),
                children: [
                  const TextSpan(text: 'NIM: '),
                  TextSpan(
                    text: widget.nim,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LuminousTextField(
              label: 'Password Baru',
              hint: '••••••••',
              controller: _pwCtrl,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            LuminousTextField(
              label: 'Konfirmasi Password Baru',
              hint: '••••••••',
              controller: _cpwCtrl,
              obscureText: true,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                _error,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleReset,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text('Simpan Password'),
            ),
          ],
        ),
      ),
    );
  }
}
