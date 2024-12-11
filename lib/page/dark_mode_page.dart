import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamly/util/color.dart';

import '../provider/theme_provider.dart';

/// Dark Mode Page
class DarkModePage extends StatefulWidget {
  @override
  _DarkModePageState createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const _ITEMS = [
    {"name": 'Follow System', "mode": ThemeMode.system},
    {"name": 'Dark Mode', "mode": ThemeMode.dark},
    {"name": 'Light Mode', "mode": ThemeMode.light},
  ];
  var _currentTheme;

  @override
  void initState() {
    super.initState();
    var themeMode = context.read<ThemeProvider>().getThemeMode();
    _ITEMS.forEach((element) {
      if (element['mode'] == themeMode) {
        _currentTheme = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavigationBar(context), // Use custom navigation bar
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _item(index);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: _ITEMS.length),
    );
  }

  AppBar _buildNavigationBar(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false, // Remove default back button
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                  ] // Dark mode gradient
                : [
                    Colors.blue.shade50,
                    Colors.blue.shade500,
                  ], // Light mode gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black54.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3), // Slight shadow for depth
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Go back to the previous screen
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: isDarkMode ? Colors.white : Colors.black, // Dynamic color
              size: 20,
            ),
          ),
          // Title
          Text(
            'System Mode',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Dynamic color
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: isDarkMode
                      ? Colors.black87 // Subtle shadow for dark mode
                      : Colors.black26, // Subtle shadow for light mode
                ),
              ],
            ),
          ),
          // Placeholder for alignment
          SizedBox(width: 20), // To balance the space taken by the back button
        ],
      ),
    );
  }

  Widget _item(int index) {
    var theme = _ITEMS[index];
    return InkWell(
      onTap: () {
        _switchTheme(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text(theme['name'] as String)),
            Opacity(
                opacity: _currentTheme == theme ? 1 : 0,
                child: Icon(Icons.done, color: primaryColor))
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme = _ITEMS[index];
    context.read<ThemeProvider>().setTheme(theme['mode'] as ThemeMode);
    setState(() {
      _currentTheme = theme;
    });
  }
}
