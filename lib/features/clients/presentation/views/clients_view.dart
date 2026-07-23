import 'package:flutter/material.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.clients),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_rounded,
              size: 64,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.clients,
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
