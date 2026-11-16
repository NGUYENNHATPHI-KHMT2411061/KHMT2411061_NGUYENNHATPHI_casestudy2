import 'package:flutter/material.dart';

import 'models/user.dart';
import 'screens/auth/login_screen.dart';
import 'screens/tasks/task_detail_screen.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/task_service.dart';
import 'services/task_share_service.dart';
import 'services/user_service.dart';
import 'services/statistics_service.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  final ApiClient _client = ApiClient();
  late final AuthService _auth = AuthService(_client);
  late final TaskService _tasks = TaskService(_client);
  late final NotificationService _notifications = NotificationService(_client);
  late final TaskShareService _shares = TaskShareService(_client);
  late final UserService _users = UserService(_client);
  late final StatisticsService _statistics = StatisticsService(_client);
  User? _user;

  void _authenticated(User user) => setState(() => _user = user);

  void _logout() {
    _auth.logout();
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    // Bảng màu vàng - trắng
    const primaryYellow = Color(0xFFFFC107); // nền nút, FAB
    const deepYellow = Color(0xFF9A6700); // chữ/icon vàng đậm trên nền trắng
    const softYellow = Color(0xFFFFF3C4); // nền chọn, highlight nhẹ
    const backgroundWhite = Color(0xFFFFFDF7); // nền trắng ngả kem
    const onYellow = Color(0xFF2B2000); // chữ trên nền vàng
    const neutralText = Color(0xFF5F5646);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryYellow,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryYellow,
      onPrimary: onYellow,
      secondary: deepYellow,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1F1A0F),
      outline: const Color(0xFFFFD54F),
    );
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: backgroundWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: deepYellow,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: softYellow,
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? deepYellow
                  : neutralText,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? deepYellow
                  : neutralText,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFFFE9A8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          floatingLabelStyle: const TextStyle(color: deepYellow),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: .7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryYellow, width: 1.8),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryYellow,
            foregroundColor: onYellow,
            minimumSize: const Size.fromHeight(46),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: deepYellow,
            side: const BorderSide(color: primaryYellow),
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: deepYellow,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryYellow,
          foregroundColor: onYellow,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: primaryYellow,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF2B2000),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: _user == null
          ? LoginScreen(authService: _auth, onAuthenticated: _authenticated)
          : TaskDetailScreen(
              user: _user!,
              taskService: _tasks,
              notificationService: _notifications,
              taskShareService: _shares,
              userService: _users,
              statisticsService: _statistics,
              onLogout: _logout,
            ),
    );
  }
}
