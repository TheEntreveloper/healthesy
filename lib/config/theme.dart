import 'package:flutter/material.dart';

const textThemeLight = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Tenor',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: Colors.black,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Tenor',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.black,
  ),
  bodyMedium: TextStyle(fontFamily: 'Tenor', color: Colors.black),
  titleMedium: TextStyle(
    fontFamily: 'Tenor',
    color: Colors.black,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Tenor',
    fontWeight: FontWeight.w300,
    fontSize: 18,
    color: Colors.black,
  ),
    displaySmall: TextStyle(
      fontFamily: 'Tenor',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    )
);

const textThemeDark = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Tenor',
      fontWeight: FontWeight.w700,
      fontSize: 28,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Tenor',
      fontWeight: FontWeight.w500,
      fontSize: 24,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontFamily: 'Tenor', color: Colors.white),
    titleMedium: TextStyle(
      fontFamily: 'Tenor',
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Tenor',
      fontWeight: FontWeight.w300,
      fontSize: 18,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Tenor',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    )
);

ColorScheme darkColorScheme = ThemeData.dark().colorScheme.
copyWith(primary: const Color(0xFF121212), // app bar
    onPrimary: const Color(0xFFC0CCCC),
    secondary: const Color(0xFF2F2F2F),
    primaryContainer: const Color(0xFF88D5D5), onPrimaryContainer: const Color(0xFF2F2F2F), // selected tab bg and foreground
    surface: const Color(0xFF292929),
    onSurface: const Color(0xFFF4F5F5),
    tertiary: const Color(0xFFC0CCCC));

ColorScheme lightColorScheme = ThemeData.light().colorScheme.
copyWith(primary: const Color(0xFF00a5a5), // app bar
    onPrimary: Colors.white,
    secondary: const Color(0xFFF4F5F5),
    primaryContainer: const Color(0xFFCAE2E2), onPrimaryContainer: const Color(0xFF314D4D), // selected tab bg and foreground
    surface: Colors.white,
    onSurface: const Color(0xFFF4F5F5),
    tertiary: const Color(0xBD314D4D));

final darkTheme = ThemeData.from(colorScheme: darkColorScheme).
copyWith(
  textTheme: textThemeDark,
  tabBarTheme: TabBarTheme(
      unselectedLabelColor: darkColorScheme.tertiary,
      labelColor: darkColorScheme.onPrimaryContainer, //Color(0xFF314D4D),// color for text
      indicator: BoxDecoration(color: darkColorScheme.primaryContainer,
          border: Border(bottom: BorderSide(color: darkColorScheme.onPrimaryContainer, width: 4, )))
  ),
);

final ThemeData lightTheme = ThemeData.from(colorScheme: lightColorScheme).
copyWith(
  textTheme: textThemeLight,
  tabBarTheme: TabBarTheme(
      unselectedLabelColor: lightColorScheme.tertiary,
      labelColor: lightColorScheme.onPrimaryContainer, //Color(0xFF314D4D),// color for text
      indicator: BoxDecoration(color: lightColorScheme.primaryContainer,
          border: const Border(bottom: BorderSide(color: Colors.black, width: 4, )))
  ),
);
var sunTheme = ThemeData.from(colorScheme: ColorScheme.fromSwatch(
primarySwatch: Colors.yellow, backgroundColor: Colors.black,cardColor: const Color(0xFFFFF9C4))).copyWith(textTheme: textThemeLight);
// copyWith(textTheme: textThemeLight, backgroundColor: Colors.yellow,
//     primaryColor: Colors.yellow, canvasColor: Colors.yellowAccent,
//     scaffoldBackgroundColor: Colors.yellow, );
var appTheme = sunTheme;
