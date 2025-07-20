import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/data/repositories/auth_repository.dart';
import 'package:wattsense/data/repositories/configuration_repository.dart';
import 'package:wattsense/data/repositories/history_repository.dart';
import 'package:wattsense/presentation/pages/auth_page/auth_wrapper.dart';
import 'package:wattsense/presentation/pages/auth_page/cubit/auth_cubit.dart';
import 'package:wattsense/presentation/pages/auth_page/login/login_page.dart';
import 'package:wattsense/presentation/pages/history_page/cubit/history_cubit.dart';
import 'package:wattsense/presentation/pages/profile_page/usage_configuration/cubit/configuration_cubit.dart';
import 'package:wattsense/presentation/widgets/main_navigation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Aplikasi utama yang sekarang menyediakan semua Cubit secara global.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MultiBlocProvider untuk menyediakan semua Cubit ke seluruh aplikasi.
    return MultiBlocProvider(
      providers: [
        // 1. Cubit untuk Otentikasi
        BlocProvider(
          // Lazy: false memastikan cubit ini langsung dibuat saat aplikasi start.
          lazy: false,
          create: (context) => AuthCubit(AuthRepository())..checkAuthStatus(),
        ),
        // 2. Cubit untuk Data Riwayat
        BlocProvider(
          create: (context) =>
              HistoryCubit(HistoryRepository())..fetchHistoryPageData(),
        ),
        // 3. Cubit untuk Konfigurasi
        BlocProvider(
          create: (context) => ConfigurationCubit(ConfigurationRepository())
            ..fetchConfiguration(),
        ),
      ],
      child: MaterialApp(
        title: 'WattSense',
        debugShowCheckedModeBanner: false,
        // DIUBAH: Menggunakan navigatorKey dan routes
        navigatorKey: navigatorKey,
        // Halaman awal sekarang dikelola oleh AuthWrapper
        home: const AuthWrapper(),
        // Mendefinisikan rute yang bisa dinavigasi di dalam aplikasi
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const MainNavigation(),
        },
      ),
    );
  }
}
