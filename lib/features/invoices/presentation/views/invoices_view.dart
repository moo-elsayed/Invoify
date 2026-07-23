import 'package:flutter/material.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';

class InvoicesView extends StatelessWidget {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.invoices),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.invoices,
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
