import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  static final appBarColor = Colors.blue.shade500.withValues(alpha: 0.9);
  static final secondaryOrangeColor =
      Colors.orange.shade500.withValues(alpha: 0.9);

  static final fab_bg = Colors.orange.shade300;
  static final fab_fg = Colors.white;

  static final _theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    fontFamily: "IBM",

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        foregroundColor: const WidgetStatePropertyAll(Colors.blue),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        overlayColor: WidgetStatePropertyAll(Colors.amber.shade500),
        surfaceTintColor: WidgetStatePropertyAll(Colors.amber.shade500),
        mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        backgroundColor: const WidgetStatePropertyAll(Colors.blue),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        overlayColor: WidgetStatePropertyAll(Colors.amber.shade500),
        surfaceTintColor: WidgetStatePropertyAll(Colors.amber.shade500),
        mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Colors.white,
      thickness: 3,
      space: 3,
      indent: 20,
      endIndent: 20,
    ),

    appBarTheme: AppBarTheme(
      color: appBarColor,
      elevation: 8,
      centerTitle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
      ),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),

    scaffoldBackgroundColor: Colors.blue.shade100.withValues(alpha: 0.5),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 0.8),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    ),

    drawerTheme: const DrawerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.elliptical(8, 8),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: fab_fg,
      backgroundColor: fab_bg,
    ),

    popupMenuTheme: PopupMenuThemeData(
      iconColor: Colors.white,
    ),

    // menuButtonTheme: MenuButtonThemeData(
    //   style: ButtonStyle(
    //     shape: WidgetStatePropertyAll(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //     ),
    //     elevation: WidgetStatePropertyAll(6),
    //     shadowColor: WidgetStatePropertyAll(Colors.grey),
    //     backgroundColor: WidgetStatePropertyAll(Colors.orange.shade300),
    //     foregroundColor: WidgetStatePropertyAll(Colors.white),
    //   ),
    // ),
    // popupMenuTheme: PopupMenuThemeData(
    //   shadowColor: Colors.grey,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadiusGeometry.circular(8),
    //   ),
    //   iconColor: Colors.white,
    //   elevation: 8,
    // ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.blue.shade50,
    ),
  );

  static ThemeData get theme => _theme;

  static BoxDecoration searchContainerDecoration = BoxDecoration(
    border: Border.all(
      width: 3,
      color: Colors.blue.shade800,
    ),
  );

  static Color mainFontColor = Colors.blueGrey.shade500;

  static const Color greyBackgroundColor = Color(0xffEEF0F2);
}
