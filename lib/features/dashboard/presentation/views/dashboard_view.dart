import 'package:flutter/material.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_rounded,
              size: 64,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.home,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.mainText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
