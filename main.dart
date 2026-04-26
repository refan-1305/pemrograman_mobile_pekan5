// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------

//------- Library ---------
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/shared_widgets.dart';

void main() {
  runApp(const LuminousApp());
}

class LuminousApp extends StatelessWidget {
  const LuminousApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminous',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatefulWidget {
  const _AppRouter();

  @override
  State<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<_AppRouter> {
  User? _user;
  AppTab _activeTab = AppTab.dashboard;

  void _handleLogin(User user) => setState(() => _user = user);

  void _handleLogout() => setState(() {
        _user = null;
        _activeTab = AppTab.dashboard;
      });

  void _handleTabChange(AppTab tab) => setState(() => _activeTab = tab);

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return AuthScreen(onLogin: _handleLogin);
    }

    return switch (_activeTab) {
      AppTab.profile => ProfileScreen(
          activeTab: _activeTab,
          onTabChange: _handleTabChange,
          onLogout: _handleLogout,
          user: _user!,
        ),
      _ => DashboardScreen(
          activeTab: _activeTab,
          onTabChange: _handleTabChange,
          user: _user!,
        ),
    };
  }
}
