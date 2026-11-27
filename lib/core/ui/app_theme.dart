import 'package:flutter/material.dart';

/// 투두펫 색. 크림·복숭아 바탕, 갈색 글자·테두리, 분홍 강조 (참고 디자인 2026-11-27).
abstract final class AppColors {
  /// 화면 바탕
  static const cream = Color(0xFFFFF8EF);

  /// 카드·시트 바탕
  static const paper = Color(0xFFFFFDF8);

  /// 글자와 진한 테두리
  static const ink = Color(0xFF5B4037);

  /// 보조 글자
  static const inkSoft = Color(0xFF8D6E63);

  /// 연한 테두리·구분선
  static const line = Color(0xFFEBD5C7);

  /// 강조(선택된 탭, 주 버튼)
  static const pink = Color(0xFFF08A8A);

  /// 선택 배경
  static const pinkSoft = Color(0xFFFDE3E1);

  /// 노란 버튼·포인트 알약 바탕
  static const butter = Color(0xFFFFEBAF);

  /// 포인트 동전
  static const coin = Color(0xFFF5B93E);

  /// 기본 방(배경 그림이 생기기 전 코드로 그림)
  static const wall = Color(0xFFFCE6DA);
  static const floor = Color(0xFFF7CDB9);

  /// 상태 게이지
  static const mood = Color(0xFFF49CA8);
  static const hunger = Color(0xFFF7C948);
  static const affection = Color(0xFFE57373);
}

/// 제목·버튼·숫자용 둥근 글꼴. 굵기는 하나뿐이라 굵게 지정하지 않는다.
const displayFont = 'Jua';

TextStyle? _display(TextStyle? s) =>
    s?.copyWith(fontFamily: displayFont, fontWeight: FontWeight.w400);

ThemeData buildAppTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.pink,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.pink,
        onPrimary: Colors.white,
        primaryContainer: AppColors.pinkSoft,
        onPrimaryContainer: AppColors.ink,
        secondary: AppColors.coin,
        secondaryContainer: AppColors.butter,
        onSecondaryContainer: AppColors.ink,
        surface: AppColors.cream,
        onSurface: AppColors.ink,
        onSurfaceVariant: AppColors.inkSoft,
        surfaceContainerLowest: AppColors.paper,
        surfaceContainerLow: AppColors.paper,
        surfaceContainer: AppColors.paper,
        surfaceContainerHigh: const Color(0xFFFFF3E6),
        surfaceContainerHighest: const Color(0xFFF8E8DA),
        outline: AppColors.ink,
        outlineVariant: AppColors.line,
      );

  final base = ThemeData(colorScheme: scheme);
  // ThemeData의 textTheme에는 글자 크기가 없다(화면에서 언어별로 합쳐짐). 테마 안에서
  // 크기를 쓰려고 한국어(dense) 크기를 미리 합친다.
  final t = base.typography.dense.merge(base.textTheme);
  final textTheme = t
      .copyWith(
        displayLarge: _display(t.displayLarge),
        displayMedium: _display(t.displayMedium),
        displaySmall: _display(t.displaySmall),
        headlineLarge: _display(t.headlineLarge),
        headlineMedium: _display(t.headlineMedium),
        headlineSmall: _display(t.headlineSmall),
        titleLarge: _display(t.titleLarge),
        titleMedium: _display(t.titleMedium),
        titleSmall: _display(t.titleSmall),
        labelLarge: _display(t.labelLarge),
      )
      .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);

  const stadium = StadiumBorder();
  final rounded20 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: const BorderSide(color: AppColors.line, width: 1.5),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.headlineSmall,
    ),
    cardTheme: CardThemeData(
      color: AppColors.paper,
      elevation: 0,
      shape: rounded20,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: stadium,
        textStyle: textTheme.titleMedium,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: stadium,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.ink, width: 1.5),
        textStyle: textTheme.titleMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ink,
        textStyle: textTheme.titleSmall,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.pink,
      foregroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: AppColors.ink, width: 2)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.pinkSoft,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      height: 72,
      labelTextStyle: WidgetStatePropertyAll(
        textTheme.labelLarge?.copyWith(color: AppColors.ink),
      ),
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(color: AppColors.ink, size: 28),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.paper,
      side: const BorderSide(color: AppColors.line, width: 1.5),
      shape: stadium,
      labelStyle: textTheme.labelLarge?.copyWith(color: AppColors.ink),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: textTheme.titleLarge?.copyWith(color: AppColors.ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.pink, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.pink,
      linearTrackColor: AppColors.line,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.line),
    listTileTheme: const ListTileThemeData(iconColor: AppColors.ink),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: const BorderSide(color: AppColors.ink, width: 1.5),
    ),
    // 선택한 탭을 분홍 알약으로 채운다 (PillTabBar가 바깥 테두리를 그림).
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.inkSoft,
      indicator: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(14),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: textTheme.titleMedium,
      unselectedLabelStyle: textTheme.titleMedium,
      dividerHeight: 0,
      splashBorderRadius: BorderRadius.circular(14),
    ),
  );
}
