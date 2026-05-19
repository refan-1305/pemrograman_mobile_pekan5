// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class LocationScreen extends StatefulWidget {
  final AppTab activeTab;
  final ValueChanged<AppTab> onTabChange;
  final User user;

  const LocationScreen({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.user,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? _latitude;
  double? _longitude;
  String _permissionStatus = 'Tidak Diketahui';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final permission = await Geolocator.checkPermission();
    setState(() {
      _permissionStatus = _getPermissionStatusText(permission);
    });
  }

  String _getPermissionStatusText(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Ditolak';
      case LocationPermission.deniedForever:
        return 'Ditolak Selamanya';
      case LocationPermission.whileInUse:
        return 'Saat Digunakan';
      case LocationPermission.always:
        return 'Selalu';
      case LocationPermission.unableToDetermine:
        return 'Tidak Dapat Ditentukan';
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Izin lokasi ditolak selamanya. Silakan ubah di pengaturan aplikasi.';
          _isLoading = false;
        });
        return;
      }

      if (permission != LocationPermission.denied) {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _permissionStatus = _getPermissionStatusText(permission);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBg,
      body: Stack(
        children: [
          Column(
            children: [
              AppHeader(subtitle: 'Lokasi GPS', user: widget.user),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
          Positioned(
            bottom: 96,
            right: 28,
            child: _VideoFAB(),
          ),
          BottomNavBar(activeTab: widget.activeTab, onTabChange: widget.onTabChange),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
      children: [
        Text(
          'Informasi Lokasi',
          style: AppTextStyles.display.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Dapatkan koordinat lokasi Anda saat ini',
          style: AppTextStyles.body.copyWith(color: AppColors.brandTextSubtle),
        ),
        const SizedBox(height: 32),
        _buildLocationCard(),
        const SizedBox(height: 24),
        _buildPermissionCard(),
        const SizedBox(height: 24),
        _buildGetLocationButton(),
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          _buildErrorCard(),
        ],
      ],
    );
  }

  Widget _buildLocationCard() {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.brandPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Koordinat Lokasi',
                style: AppTextStyles.title.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCoordinateItem(
            label: 'Latitude',
            value: _latitude != null ? _latitude.toString() : 'Belum diambil',
            icon: Icons.north_rounded,
          ),
          const SizedBox(height: 16),
          _buildCoordinateItem(
            label: 'Longitude',
            value: _longitude != null ? _longitude.toString() : 'Belum diambil',
            icon: Icons.east_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandPrimary.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandPrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.brandTextSubtle,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.title.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard() {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  color: AppColors.brandPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Status Izin',
                style: AppTextStyles.title.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.brandPrimary.withOpacity(0.3),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              _permissionStatus,
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                color: AppColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetLocationButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isLoading ? null : _getCurrentLocation,
        icon: _isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                ),
              )
            : const Icon(Icons.my_location_rounded, size: 20),
        label: Text(_isLoading ? 'Mengambil Lokasi...' : 'Ambil Lokasi Terkini'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.body.copyWith(
                color: Colors.red.shade600,
                fontSize: 13,
              ),
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
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.brandPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.video_camera_back_rounded, color: Colors.white, size: 24),
    );
  }
}
