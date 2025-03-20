import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Switch.adaptive(
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
